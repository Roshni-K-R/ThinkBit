import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> isUserBlocked(BuildContext context,String userId) async {
  try {
    final res = await Supabase.instance.client
        .from('profiles')
        .select('blocked_until, status')
        .eq('id', userId)
        .single();


    final blockedUntil = res['blocked_until'];
    final status = res['status'];

    if (status == 'permanently_blocked') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚫 You are permanently blocked from posting.'),
          backgroundColor: Colors.red,
        ),
      );

      return true; // Blocked
    }

    if (status == 'blocked' && blockedUntil != null) {
      final now = DateTime.now().toUtc();
      final unblockTime = DateTime.parse(blockedUntil);

      if (now.isBefore(unblockTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⏳ You are temporarily blocked until ${unblockTime.toLocal()}.'),
            backgroundColor: Colors.orange,
          ),
        );
        return true; // Still blocked
      }



      // ✅ Auto-unblock if block expired
      await Supabase.instance.client.from('profiles').update({
        'status': 'active',
        'blocked_until': null,
      }).eq('id', userId);

      print("✅ User $userId unblocked automatically.");
    }

    return false; // Not blocked
  } catch (e) {
    print('❌ Error checking block status: $e');
    return false;
  }
}