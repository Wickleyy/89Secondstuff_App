import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class AdminChatListController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var isLoading = true.obs;
  var chatList = <Profile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
  }

  void fetchChatList() async {
    try {
      isLoading.value = true;
      final adminId = _supabase.currentUser!.id;

      final response = await _supabase.client
          .from('messages')
          .select('sender_id, receiver_id')
          .or('sender_id.eq.$adminId,receiver_id.eq.$adminId');

      final allMessages = response as List;
      final userIds = <String>{};

      for (var msg in allMessages) {
        if (msg['sender_id'] != adminId) userIds.add(msg['sender_id']);
        if (msg['receiver_id'] != adminId) userIds.add(msg['receiver_id']);
      }

      if (userIds.isEmpty) {
        isLoading.value = false;
        return;
      }

      final profilesResponse = await _supabase.client
          .from('profiles')
          .select()
          .inFilter('id', userIds.toList()); // V2: inFilter

      final profiles = (profilesResponse as List)
          .map((data) => Profile.fromJson(data))
          .toList();

      chatList.assignAll(profiles);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat daftar chat: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToChatDetail(Profile userProfile) {
    Get.toNamed(AppRoutes.ADMIN_CHAT_DETAIL, arguments: userProfile);
  }
}
