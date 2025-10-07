class DashboardInfo {
  final MemberStats members;
  final ActivityStats activities;
  final PaymentStats payments;
  final StudentStats students;
  final List<HighMember> highMembers;

  DashboardInfo({
    required this.members,
    required this.activities,
    required this.payments,
    required this.students,
    required this.highMembers,
  });

  factory DashboardInfo.fromJson(Map<String, dynamic> json) {
    return DashboardInfo(
      members: MemberStats.fromJson(json['members']),
      activities: ActivityStats.fromJson(json['activities']),
      payments: PaymentStats.fromJson(json['payments']),
      students: StudentStats.fromJson(json['students']),
      highMembers: (json['highMembers'] as List)
          .map((e) => HighMember.fromJson(e))
          .toList(),
    );
  }
}

class MemberStats {
  final String totalMembers;
  final String totalLeader;
  final String totalSubLeader;
  final String totalMember;

  MemberStats({
    required this.totalMembers,
    required this.totalLeader,
    required this.totalSubLeader,
    required this.totalMember,
  });

  factory MemberStats.fromJson(Map<String, dynamic> json) {
    return MemberStats(
      totalMembers: json['total_members'] ?? '',
      totalLeader: json['total_leader'] ?? '',
      totalSubLeader: json['total_sub_leader'] ?? '',
      totalMember: json['total_member'] ?? '',
    );
  }
}

class ActivityStats {
  final String totalActivities;
  final String totalOld;
  final String totalNew;

  ActivityStats({
    required this.totalActivities,
    required this.totalOld,
    required this.totalNew,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) {
    return ActivityStats(
      totalActivities: json['total_activities'] ?? '',
      totalOld: json['total_old'] ?? '',
      totalNew: json['total_new'] ?? '',
    );
  }
}

class PaymentStats {
  final String totalAmount;
  final String totalPayments;
  final String totalTransactions;

  PaymentStats({
    required this.totalAmount,
    required this.totalPayments,
    required this.totalTransactions,
  });

  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      totalAmount: json['total_amount'] ?? '',
      totalPayments: json['total_payments'] ?? '',
      totalTransactions: json['total_transactions'] ?? '',
    );
  }
}

class StudentStats {
  final String totalStudents;
  final String totalActive;
  final String totalInactive;

  StudentStats({
    required this.totalStudents,
    required this.totalActive,
    required this.totalInactive,
  });

  factory StudentStats.fromJson(Map<String, dynamic> json) {
    return StudentStats(
      totalStudents: json['total_students'] ?? '',
      totalActive: json['total_active'] ?? '',
      totalInactive: json['total_inactive'] ?? '',
    );
  }
}

class HighMember {
  final String nameKh;
  final String cppPosition;
  final String phone;
  final String job;
  final String? image;

  HighMember({
    required this.nameKh,
    required this.cppPosition,
    required this.phone,
    required this.job,
    this.image,
  });

  factory HighMember.fromJson(Map<String, dynamic> json) {
    return HighMember(
      nameKh: json['name_kh'] ?? '',
      cppPosition: json['cpp_position'] ?? '',
      phone: json['phone_number'] ?? '',
      job: json['job'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
