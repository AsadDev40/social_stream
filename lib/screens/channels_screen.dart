// ignore_for_file: library_private_types_in_public_api

import 'package:channelhub/model/channel_model.dart';
import 'package:channelhub/provider/channel_provider.dart';
import 'package:channelhub/screens/channel_detail_screen.dart';
import 'package:channelhub/widgets/channel_list.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChannelsScreen extends StatefulWidget {
  final String category;
  final String categoryId;

  const ChannelsScreen({
    super.key,
    required this.category,
    required this.categoryId,
  });

  @override
  _ChannelsScreenState createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Channel>> _channelsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Set up an initial call to _fetchChannels based on the current tab index
    int initialTabIndex = _tabController.index;
    _channelsFuture = _fetchChannels(initialTabIndex);

    // Add a listener to update _channelsFuture whenever the tab selection changes
    _tabController.addListener(_handleTabSelectionChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(
        _handleTabSelectionChange); // Ensure to remove the listener
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Channel>> _fetchChannels(int? tabIndex) {
    return Provider.of<ChannelProvider>(context, listen: false)
        .fetchChannelsByCategory(widget.categoryId,
            tabIndex != null && tabIndex == 0 ? 'telegram' : 'whatsapp');
  }

  void _handleTabSelectionChange() {
    // Update _channelsFuture based on the new tab index
    setState(() {
      _channelsFuture = _fetchChannels(_tabController.index);
    });
  }

  Future<void> _refreshChannels() async {
    setState(() {
      _channelsFuture = _fetchChannels(_tabController.index);
    });
  }

  void _onChannelTap(String channelId) {
    String channelType = _tabController.index == 0 ? 'telegram' : 'whatsapp';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelDetailScreen(
          channelId: channelId,
          categoryId: widget.categoryId,
          channelType: channelType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Channels'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Telegram'),
              Tab(text: 'WhatsApp'),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.amber,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChannelList('telegram'),
                _buildChannelList('whatsapp'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelList(String type) {
    return FutureBuilder<List<Channel>>(
      future: _channelsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading channels'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No channels found'));
        }

        final channels = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refreshChannels,
          child: ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel.name),
                subtitle: Text('Type: ${channel.type.capitalize()}'),
                onTap: () {
                  _onChannelTap(channel.id);
                },
              );
            },
          ),
        );
      },
    );
  }
}
