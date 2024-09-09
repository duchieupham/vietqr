import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/features/connect_media/blocs/connect_media_bloc.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/connect_media/events/connect_media_evens.dart';
import 'package:vierqr/features/connect_media/states/connect_media_states.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/B%C4%90SD/discord_dto.dart';
import 'package:vierqr/models/B%C4%90SD/gg_chat_dto.dart';
import 'package:vierqr/models/B%C4%90SD/gg_sheet_dto.dart';
import 'package:vierqr/models/B%C4%90SD/lark_dto.dart';
import 'package:vierqr/models/B%C4%90SD/slack_dto.dart';
import 'package:vierqr/models/B%C4%90SD/tele_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';

class ListMediaScreen extends StatefulWidget {
  final TypeConnect type;
  const ListMediaScreen({
    super.key,
    required this.type,
  });

  @override
  State<ListMediaScreen> createState() => _ListMediaScreenState();
}

class _ListMediaScreenState extends State<ListMediaScreen> {
  final ScrollController _controller = ScrollController();

  final _bloc = getIt.get<ConnectMediaBloc>();

  @override
  void initState() {
    super.initState();
    if (widget.type == TypeConnect.GG_CHAT) {
      _bloc.add(const GetListGGChatEvent(isLoadMore: false, page: 1, size: 20));
    }
    if (widget.type == TypeConnect.TELE) {
      _bloc.add(const GetListTeleEvent(isLoadMore: false, page: 1, size: 20));
    }
    if (widget.type == TypeConnect.LARK) {
      _bloc.add(const GetListLarkEvent(isLoadMore: false, page: 1, size: 20));
    }
    if (widget.type == TypeConnect.SLACK) {
      _bloc.add(const GetListSlackEvent(isLoadMore: false, page: 1, size: 20));
    }
    if (widget.type == TypeConnect.DISCORD) {
      _bloc
          .add(const GetListDiscordEvent(isLoadMore: false, page: 1, size: 20));
    }
    if (widget.type == TypeConnect.GG_SHEET) {
      _bloc
          .add(const GetListGGSheetEvent(isLoadMore: false, page: 1, size: 20));
    }

    _controller.addListener(
      () {
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          if (metadata != null) {
            int total = (metadata!.total! / 20).ceil();
            if (total > metadata!.page!) {
              if (widget.type == TypeConnect.GG_CHAT) {
                _bloc.add(const GetListGGChatEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
              if (widget.type == TypeConnect.TELE) {
                _bloc.add(const GetListTeleEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
              if (widget.type == TypeConnect.LARK) {
                _bloc.add(const GetListLarkEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
              if (widget.type == TypeConnect.SLACK) {
                _bloc.add(const GetListSlackEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
              if (widget.type == TypeConnect.DISCORD) {
                _bloc.add(const GetListDiscordEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
              if (widget.type == TypeConnect.GG_SHEET) {
                _bloc.add(const GetListGGSheetEvent(
                    isLoadMore: true, page: 1, size: 20));
              }
            }
          }
        }
      },
    );
  }

  MetaDataDTO? metadata;

  @override
  Widget build(BuildContext context) {
    String name = '';
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        name = 'Google chat';
        break;
      case TypeConnect.TELE:
        name = 'Telegram';
        break;
      case TypeConnect.LARK:
        name = 'Lark';
        break;
      case TypeConnect.SLACK:
        name = 'Slack';
        break;
      case TypeConnect.DISCORD:
        name = 'Discord';
        break;
      case TypeConnect.GG_SHEET:
        name = 'Google Sheet';
        break;
      default:
    }
    return BlocConsumer<ConnectMediaBloc, ConnectMediaStates>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.request == ConnectMedia.DELETE_URL &&
            state.status == BlocStatus.SUCCESS) {
          if (widget.type == TypeConnect.GG_CHAT) {
            _bloc.add(
                const GetListGGChatEvent(isLoadMore: false, page: 1, size: 20));
          }
          if (widget.type == TypeConnect.TELE) {
            _bloc.add(
                const GetListTeleEvent(isLoadMore: false, page: 1, size: 20));
          }
          if (widget.type == TypeConnect.LARK) {
            _bloc.add(
                const GetListLarkEvent(isLoadMore: false, page: 1, size: 20));
          }
          if (widget.type == TypeConnect.SLACK) {
            _bloc.add(
                const GetListSlackEvent(isLoadMore: false, page: 1, size: 20));
          }
          if (widget.type == TypeConnect.DISCORD) {
            _bloc.add(const GetListDiscordEvent(
                isLoadMore: false, page: 1, size: 20));
          }
          if (widget.type == TypeConnect.GG_SHEET) {
            _bloc.add(const GetListGGSheetEvent(
                isLoadMore: false, page: 1, size: 20));
          }
        }
      },
      builder: (context, state) {
        List<GoogleChatDTO> listChat = [];
        List<LarkDTO> listLark = [];
        List<TeleDTO> listTele = [];
        List<SlackDTO> listSlack = [];
        List<DiscordDTO> listDiscord = [];
        List<GoogleSheetDTO> listSheet = [];

        if (state.request == ConnectMedia.GET_LIST_CHAT &&
            state.status == BlocStatus.LOAD_MORE) {
          listChat = [...listChat, ...state.listChat!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_LARK &&
            state.status == BlocStatus.LOAD_MORE) {
          listLark = [...listLark, ...state.listLark!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_TELE &&
            state.status == BlocStatus.LOAD_MORE) {
          listTele = [...listTele, ...state.listTele!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_SLACK &&
            state.status == BlocStatus.LOAD_MORE) {
          listSlack = [...listSlack, ...state.listSlack!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_DISCORD &&
            state.status == BlocStatus.LOAD_MORE) {
          listDiscord = [...listDiscord, ...state.listDiscord!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_SHEET &&
            state.status == BlocStatus.LOAD_MORE) {
          listSheet = [...listSheet, ...state.listGgSheet!];
          metadata = state.metadata;
        }

        ///Danh sách bank media
        if (state.request == ConnectMedia.GET_LIST_CHAT &&
            state.status == BlocStatus.SUCCESS) {
          listChat = [...state.listChat!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_LARK &&
            state.status == BlocStatus.SUCCESS) {
          listLark = [...state.listLark!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_TELE &&
            state.status == BlocStatus.SUCCESS) {
          listTele = [...state.listTele!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_SLACK &&
            state.status == BlocStatus.SUCCESS) {
          listSlack = [...state.listSlack!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_DISCORD &&
            state.status == BlocStatus.SUCCESS) {
          listDiscord = [...state.listDiscord!];
          metadata = state.metadata;
        }
        if (state.request == ConnectMedia.GET_LIST_SHEET &&
            state.status == BlocStatus.SUCCESS) {
          listSheet = [...state.listGgSheet!];
          metadata = state.metadata;
        }

        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: _appbar(),
          body: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách kết nối\nqua nền tảng $name',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (widget.type == TypeConnect.GG_CHAT) ...[
                          if (listChat.isNotEmpty)
                            ...listChat.map(
                              (e) => _buildItem(chat: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ] else if (widget.type == TypeConnect.TELE) ...[
                          if (listTele.isNotEmpty)
                            ...listTele.map(
                              (e) => _buildItem(tele: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ] else if (widget.type == TypeConnect.LARK) ...[
                          if (listLark.isNotEmpty)
                            ...listLark.map(
                              (e) => _buildItem(lark: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ] else if (widget.type == TypeConnect.SLACK) ...[
                          if (listSlack.isNotEmpty)
                            ...listSlack.map(
                              (e) => _buildItem(slack: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ] else if (widget.type == TypeConnect.DISCORD) ...[
                          if (listDiscord.isNotEmpty)
                            ...listDiscord.map(
                              (e) => _buildItem(discord: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ] else if (widget.type == TypeConnect.GG_SHEET) ...[
                          if (listSheet.isNotEmpty)
                            ...listSheet.map(
                              (e) => _buildItem(sheet: e),
                            )
                          else
                            const Center(
                              child: Text('Trống'),
                            ),
                        ],
                        if (state.request == ConnectMedia.LOAD_MORE)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem({
    GoogleChatDTO? chat,
    LarkDTO? lark,
    TeleDTO? tele,
    SlackDTO? slack,
    DiscordDTO? discord,
    GoogleSheetDTO? sheet,
  }) {
    String url = '';
    String id = '';
    int bankAcc = 0;
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        id = chat!.googleChatId;
        url = chat.webhook;
        bankAcc = chat.bankAccountCount;
        break;
      case TypeConnect.TELE:
        id = tele!.telegramId;
        url = tele.chatId;
        bankAcc = tele.bankAccountCount;
        break;
      case TypeConnect.LARK:
        id = lark!.larkId;
        url = lark.webhook;
        bankAcc = lark.bankAccountCount;
        break;
      case TypeConnect.SLACK:
        id = slack!.slackId;
        url = slack.webhook;
        bankAcc = slack.bankAccountCount;
        break;
      case TypeConnect.DISCORD:
        id = discord!.discordId;
        url = discord.webhook;
        bankAcc = discord.bankAccountCount;
        break;
      case TypeConnect.GG_SHEET:
        id = sheet!.ggSheetId;
        url = sheet.webhook;
        bankAcc = sheet.bankAccountCount;
        break;
      default:
    }

    return InkWell(
      onTap: () {
        switch (widget.type) {
          case TypeConnect.GG_CHAT:
            Navigator.pushNamed(context, Routes.CONNECT_GG_CHAT_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListGGChatEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );
            break;
          case TypeConnect.TELE:
            Navigator.pushNamed(context, Routes.CONNECT_TELE_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListTeleEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );

            break;
          case TypeConnect.LARK:
            Navigator.pushNamed(context, Routes.CONNECT_LARK_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListLarkEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );

            break;
          case TypeConnect.SLACK:
            Navigator.pushNamed(context, Routes.CONNECT_SLACK_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListSlackEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );
            break;
          case TypeConnect.DISCORD:
            Navigator.pushNamed(context, Routes.CONNECT_DISCORD_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListDiscordEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );
            break;
          case TypeConnect.GG_SHEET:
            Navigator.pushNamed(context, Routes.CONNECT_GG_SHEET_SCREEN,
                arguments: {'id': id}).then(
              (value) {
                _bloc.add(const GetListGGSheetEvent(
                    isLoadMore: false, page: 1, size: 20));
              },
            );
            break;
          default:
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFA6C5FF), Color(0xFFC5CDFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: const XImage(
                      imagePath: 'assets/images/ic-media-black.png'),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kết nối của Kiên',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      // const SizedBox(height: 3),
                      Text(
                        '${bankAcc.toString()} TK ngân hàng',
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.GREY_TEXT),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTapDown: (details) {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        details.globalPosition.dx,
                        details.globalPosition.dy + 20,
                        details.globalPosition.dx,
                        details.globalPosition.dy + 20,
                      ),
                      items: <PopupMenuEntry<int>>[
                        const PopupMenuItem<int>(
                          value: 0,
                          child: ListTile(
                            title: Text(
                              'Sao chép Webhook',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: ListTile(
                            title: Text(
                              'Huỷ kết nối',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ).then(
                      (value) {
                        if (value == 0) {
                          FlutterClipboard.copy(url).then(
                            (value) => Fluttertoast.showToast(
                              msg: 'Đã sao chép',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).hintColor,
                              fontSize: 15,
                              webBgColor: 'rgba(255, 255, 255, 0.5)',
                              webPosition: 'center',
                            ),
                          );
                        }
                        if (value == 1) {
                          _bloc.add(
                              DeleteWebhookEvent(id: id, type: widget.type));
                        }
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child: const XImage(
                        imagePath: 'assets/images/ic-option-black.png'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const MySeparator(color: AppColor.GREY_DADADA),
          ],
        ),
      ),
    );
  }

  _appbar() {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: AppColor.WHITE,
      leadingWidth: double.infinity,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          child: const Row(
            children: [
              Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(width: 2),
              Text(
                "Trở về",
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            switch (widget.type) {
              case TypeConnect.GG_CHAT:
                Navigator.pushNamed(context, Routes.CONNECT_GG_CHAT_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListGGChatEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );
                break;
              case TypeConnect.TELE:
                Navigator.pushNamed(context, Routes.CONNECT_TELE_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListTeleEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );

                break;
              case TypeConnect.LARK:
                Navigator.pushNamed(context, Routes.CONNECT_LARK_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListLarkEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );

                break;
              case TypeConnect.SLACK:
                Navigator.pushNamed(context, Routes.CONNECT_SLACK_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListSlackEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );

                break;
              case TypeConnect.DISCORD:
                Navigator.pushNamed(context, Routes.CONNECT_DISCORD_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListDiscordEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );

                break;
              case TypeConnect.GG_SHEET:
                Navigator.pushNamed(context, Routes.CONNECT_GG_SHEET_SCREEN,
                    arguments: {'id': ''}).then(
                  (value) {
                    _bloc.add(const GetListGGSheetEvent(
                        isLoadMore: false, page: 1, size: 20));
                  },
                );

                break;
              default:
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            child: const XImage(imagePath: 'assets/images/ic-plus-black.png'),
          ),
        ),
      ],
    );
  }
}
