// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ShopsTable extends Shops with TableInfo<$ShopsTable, Shop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => 'local_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameDariMeta =
      const VerificationMeta('nameDari');
  @override
  late final GeneratedColumn<String> nameDari = GeneratedColumn<String>(
      'name_dari', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Kabul'));
  static const VerificationMeta _districtMeta =
      const VerificationMeta('district');
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
      'district', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shopTypeMeta =
      const VerificationMeta('shopType');
  @override
  late final GeneratedColumn<String> shopType = GeneratedColumn<String>(
      'shop_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _currencyPrefMeta =
      const VerificationMeta('currencyPref');
  @override
  late final GeneratedColumn<String> currencyPref = GeneratedColumn<String>(
      'currency_pref', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('AFN'));
  static const VerificationMeta _languagePrefMeta =
      const VerificationMeta('languagePref');
  @override
  late final GeneratedColumn<String> languagePref = GeneratedColumn<String>(
      'language_pref', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('fa'));
  static const VerificationMeta _subscriptionStatusMeta =
      const VerificationMeta('subscriptionStatus');
  @override
  late final GeneratedColumn<String> subscriptionStatus =
      GeneratedColumn<String>('subscription_status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('trial'));
  static const VerificationMeta _trialEndsAtMeta =
      const VerificationMeta('trialEndsAt');
  @override
  late final GeneratedColumn<DateTime> trialEndsAt = GeneratedColumn<DateTime>(
      'trial_ends_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().add(const Duration(days: 30)));
  static const VerificationMeta _subscriptionEndsAtMeta =
      const VerificationMeta('subscriptionEndsAt');
  @override
  late final GeneratedColumn<DateTime> subscriptionEndsAt =
      GeneratedColumn<DateTime>('subscription_ends_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ownerId,
        name,
        nameDari,
        phone,
        city,
        district,
        shopType,
        currencyPref,
        languagePref,
        subscriptionStatus,
        trialEndsAt,
        subscriptionEndsAt,
        createdAt,
        updatedAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shops';
  @override
  VerificationContext validateIntegrity(Insertable<Shop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_dari')) {
      context.handle(_nameDariMeta,
          nameDari.isAcceptableOrUnknown(data['name_dari']!, _nameDariMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('district')) {
      context.handle(_districtMeta,
          district.isAcceptableOrUnknown(data['district']!, _districtMeta));
    }
    if (data.containsKey('shop_type')) {
      context.handle(_shopTypeMeta,
          shopType.isAcceptableOrUnknown(data['shop_type']!, _shopTypeMeta));
    }
    if (data.containsKey('currency_pref')) {
      context.handle(
          _currencyPrefMeta,
          currencyPref.isAcceptableOrUnknown(
              data['currency_pref']!, _currencyPrefMeta));
    }
    if (data.containsKey('language_pref')) {
      context.handle(
          _languagePrefMeta,
          languagePref.isAcceptableOrUnknown(
              data['language_pref']!, _languagePrefMeta));
    }
    if (data.containsKey('subscription_status')) {
      context.handle(
          _subscriptionStatusMeta,
          subscriptionStatus.isAcceptableOrUnknown(
              data['subscription_status']!, _subscriptionStatusMeta));
    }
    if (data.containsKey('trial_ends_at')) {
      context.handle(
          _trialEndsAtMeta,
          trialEndsAt.isAcceptableOrUnknown(
              data['trial_ends_at']!, _trialEndsAtMeta));
    }
    if (data.containsKey('subscription_ends_at')) {
      context.handle(
          _subscriptionEndsAtMeta,
          subscriptionEndsAt.isAcceptableOrUnknown(
              data['subscription_ends_at']!, _subscriptionEndsAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shop(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameDari: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_dari']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      district: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}district']),
      shopType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_type'])!,
      currencyPref: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_pref'])!,
      languagePref: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_pref'])!,
      subscriptionStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}subscription_status'])!,
      trialEndsAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}trial_ends_at'])!,
      subscriptionEndsAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}subscription_ends_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $ShopsTable createAlias(String alias) {
    return $ShopsTable(attachedDatabase, alias);
  }
}

class Shop extends DataClass implements Insertable<Shop> {
  final String id;
  final String ownerId;
  final String name;
  final String? nameDari;
  final String? phone;
  final String city;
  final String? district;
  final String shopType;
  final String currencyPref;
  final String languagePref;
  final String subscriptionStatus;
  final DateTime trialEndsAt;
  final DateTime? subscriptionEndsAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const Shop(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.nameDari,
      this.phone,
      required this.city,
      this.district,
      required this.shopType,
      required this.currencyPref,
      required this.languagePref,
      required this.subscriptionStatus,
      required this.trialEndsAt,
      this.subscriptionEndsAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameDari != null) {
      map['name_dari'] = Variable<String>(nameDari);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || district != null) {
      map['district'] = Variable<String>(district);
    }
    map['shop_type'] = Variable<String>(shopType);
    map['currency_pref'] = Variable<String>(currencyPref);
    map['language_pref'] = Variable<String>(languagePref);
    map['subscription_status'] = Variable<String>(subscriptionStatus);
    map['trial_ends_at'] = Variable<DateTime>(trialEndsAt);
    if (!nullToAbsent || subscriptionEndsAt != null) {
      map['subscription_ends_at'] = Variable<DateTime>(subscriptionEndsAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ShopsCompanion toCompanion(bool nullToAbsent) {
    return ShopsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      nameDari: nameDari == null && nullToAbsent
          ? const Value.absent()
          : Value(nameDari),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      city: Value(city),
      district: district == null && nullToAbsent
          ? const Value.absent()
          : Value(district),
      shopType: Value(shopType),
      currencyPref: Value(currencyPref),
      languagePref: Value(languagePref),
      subscriptionStatus: Value(subscriptionStatus),
      trialEndsAt: Value(trialEndsAt),
      subscriptionEndsAt: subscriptionEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionEndsAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Shop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shop(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      nameDari: serializer.fromJson<String?>(json['nameDari']),
      phone: serializer.fromJson<String?>(json['phone']),
      city: serializer.fromJson<String>(json['city']),
      district: serializer.fromJson<String?>(json['district']),
      shopType: serializer.fromJson<String>(json['shopType']),
      currencyPref: serializer.fromJson<String>(json['currencyPref']),
      languagePref: serializer.fromJson<String>(json['languagePref']),
      subscriptionStatus:
          serializer.fromJson<String>(json['subscriptionStatus']),
      trialEndsAt: serializer.fromJson<DateTime>(json['trialEndsAt']),
      subscriptionEndsAt:
          serializer.fromJson<DateTime?>(json['subscriptionEndsAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'nameDari': serializer.toJson<String?>(nameDari),
      'phone': serializer.toJson<String?>(phone),
      'city': serializer.toJson<String>(city),
      'district': serializer.toJson<String?>(district),
      'shopType': serializer.toJson<String>(shopType),
      'currencyPref': serializer.toJson<String>(currencyPref),
      'languagePref': serializer.toJson<String>(languagePref),
      'subscriptionStatus': serializer.toJson<String>(subscriptionStatus),
      'trialEndsAt': serializer.toJson<DateTime>(trialEndsAt),
      'subscriptionEndsAt': serializer.toJson<DateTime?>(subscriptionEndsAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Shop copyWith(
          {String? id,
          String? ownerId,
          String? name,
          Value<String?> nameDari = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          String? city,
          Value<String?> district = const Value.absent(),
          String? shopType,
          String? currencyPref,
          String? languagePref,
          String? subscriptionStatus,
          DateTime? trialEndsAt,
          Value<DateTime?> subscriptionEndsAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      Shop(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        nameDari: nameDari.present ? nameDari.value : this.nameDari,
        phone: phone.present ? phone.value : this.phone,
        city: city ?? this.city,
        district: district.present ? district.value : this.district,
        shopType: shopType ?? this.shopType,
        currencyPref: currencyPref ?? this.currencyPref,
        languagePref: languagePref ?? this.languagePref,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        trialEndsAt: trialEndsAt ?? this.trialEndsAt,
        subscriptionEndsAt: subscriptionEndsAt.present
            ? subscriptionEndsAt.value
            : this.subscriptionEndsAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  Shop copyWithCompanion(ShopsCompanion data) {
    return Shop(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      nameDari: data.nameDari.present ? data.nameDari.value : this.nameDari,
      phone: data.phone.present ? data.phone.value : this.phone,
      city: data.city.present ? data.city.value : this.city,
      district: data.district.present ? data.district.value : this.district,
      shopType: data.shopType.present ? data.shopType.value : this.shopType,
      currencyPref: data.currencyPref.present
          ? data.currencyPref.value
          : this.currencyPref,
      languagePref: data.languagePref.present
          ? data.languagePref.value
          : this.languagePref,
      subscriptionStatus: data.subscriptionStatus.present
          ? data.subscriptionStatus.value
          : this.subscriptionStatus,
      trialEndsAt:
          data.trialEndsAt.present ? data.trialEndsAt.value : this.trialEndsAt,
      subscriptionEndsAt: data.subscriptionEndsAt.present
          ? data.subscriptionEndsAt.value
          : this.subscriptionEndsAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shop(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('nameDari: $nameDari, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('shopType: $shopType, ')
          ..write('currencyPref: $currencyPref, ')
          ..write('languagePref: $languagePref, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('subscriptionEndsAt: $subscriptionEndsAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ownerId,
      name,
      nameDari,
      phone,
      city,
      district,
      shopType,
      currencyPref,
      languagePref,
      subscriptionStatus,
      trialEndsAt,
      subscriptionEndsAt,
      createdAt,
      updatedAt,
      syncStatus,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shop &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.nameDari == this.nameDari &&
          other.phone == this.phone &&
          other.city == this.city &&
          other.district == this.district &&
          other.shopType == this.shopType &&
          other.currencyPref == this.currencyPref &&
          other.languagePref == this.languagePref &&
          other.subscriptionStatus == this.subscriptionStatus &&
          other.trialEndsAt == this.trialEndsAt &&
          other.subscriptionEndsAt == this.subscriptionEndsAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class ShopsCompanion extends UpdateCompanion<Shop> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String?> nameDari;
  final Value<String?> phone;
  final Value<String> city;
  final Value<String?> district;
  final Value<String> shopType;
  final Value<String> currencyPref;
  final Value<String> languagePref;
  final Value<String> subscriptionStatus;
  final Value<DateTime> trialEndsAt;
  final Value<DateTime?> subscriptionEndsAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ShopsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameDari = const Value.absent(),
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.district = const Value.absent(),
    this.shopType = const Value.absent(),
    this.currencyPref = const Value.absent(),
    this.languagePref = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.trialEndsAt = const Value.absent(),
    this.subscriptionEndsAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopsCompanion.insert({
    this.id = const Value.absent(),
    required String ownerId,
    required String name,
    this.nameDari = const Value.absent(),
    this.phone = const Value.absent(),
    this.city = const Value.absent(),
    this.district = const Value.absent(),
    this.shopType = const Value.absent(),
    this.currencyPref = const Value.absent(),
    this.languagePref = const Value.absent(),
    this.subscriptionStatus = const Value.absent(),
    this.trialEndsAt = const Value.absent(),
    this.subscriptionEndsAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ownerId = Value(ownerId),
        name = Value(name);
  static Insertable<Shop> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? nameDari,
    Expression<String>? phone,
    Expression<String>? city,
    Expression<String>? district,
    Expression<String>? shopType,
    Expression<String>? currencyPref,
    Expression<String>? languagePref,
    Expression<String>? subscriptionStatus,
    Expression<DateTime>? trialEndsAt,
    Expression<DateTime>? subscriptionEndsAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (nameDari != null) 'name_dari': nameDari,
      if (phone != null) 'phone': phone,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (shopType != null) 'shop_type': shopType,
      if (currencyPref != null) 'currency_pref': currencyPref,
      if (languagePref != null) 'language_pref': languagePref,
      if (subscriptionStatus != null) 'subscription_status': subscriptionStatus,
      if (trialEndsAt != null) 'trial_ends_at': trialEndsAt,
      if (subscriptionEndsAt != null)
        'subscription_ends_at': subscriptionEndsAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ownerId,
      Value<String>? name,
      Value<String?>? nameDari,
      Value<String?>? phone,
      Value<String>? city,
      Value<String?>? district,
      Value<String>? shopType,
      Value<String>? currencyPref,
      Value<String>? languagePref,
      Value<String>? subscriptionStatus,
      Value<DateTime>? trialEndsAt,
      Value<DateTime?>? subscriptionEndsAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return ShopsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      nameDari: nameDari ?? this.nameDari,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      district: district ?? this.district,
      shopType: shopType ?? this.shopType,
      currencyPref: currencyPref ?? this.currencyPref,
      languagePref: languagePref ?? this.languagePref,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      subscriptionEndsAt: subscriptionEndsAt ?? this.subscriptionEndsAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameDari.present) {
      map['name_dari'] = Variable<String>(nameDari.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (shopType.present) {
      map['shop_type'] = Variable<String>(shopType.value);
    }
    if (currencyPref.present) {
      map['currency_pref'] = Variable<String>(currencyPref.value);
    }
    if (languagePref.present) {
      map['language_pref'] = Variable<String>(languagePref.value);
    }
    if (subscriptionStatus.present) {
      map['subscription_status'] = Variable<String>(subscriptionStatus.value);
    }
    if (trialEndsAt.present) {
      map['trial_ends_at'] = Variable<DateTime>(trialEndsAt.value);
    }
    if (subscriptionEndsAt.present) {
      map['subscription_ends_at'] =
          Variable<DateTime>(subscriptionEndsAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('nameDari: $nameDari, ')
          ..write('phone: $phone, ')
          ..write('city: $city, ')
          ..write('district: $district, ')
          ..write('shopType: $shopType, ')
          ..write('currencyPref: $currencyPref, ')
          ..write('languagePref: $languagePref, ')
          ..write('subscriptionStatus: $subscriptionStatus, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('subscriptionEndsAt: $subscriptionEndsAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_prod_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES shops (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameDariMeta =
      const VerificationMeta('nameDari');
  @override
  late final GeneratedColumn<String> nameDari = GeneratedColumn<String>(
      'name_dari', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _namePashtoMeta =
      const VerificationMeta('namePashto');
  @override
  late final GeneratedColumn<String> namePashto = GeneratedColumn<String>(
      'name_pashto', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stockQuantityMeta =
      const VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<double> stockQuantity = GeneratedColumn<double>(
      'stock_quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _minStockAlertMeta =
      const VerificationMeta('minStockAlert');
  @override
  late final GeneratedColumn<double> minStockAlert = GeneratedColumn<double>(
      'min_stock_alert', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(5.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('piece'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _prescriptionRequiredMeta =
      const VerificationMeta('prescriptionRequired');
  @override
  late final GeneratedColumn<bool> prescriptionRequired = GeneratedColumn<bool>(
      'prescription_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("prescription_required" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeVariantMeta =
      const VerificationMeta('sizeVariant');
  @override
  late final GeneratedColumn<String> sizeVariant = GeneratedColumn<String>(
      'size_variant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imeiMeta = const VerificationMeta('imei');
  @override
  late final GeneratedColumn<String> imei = GeneratedColumn<String>(
      'imei', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serialNumberMeta =
      const VerificationMeta('serialNumber');
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
      'serial_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightGramsMeta =
      const VerificationMeta('weightGrams');
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
      'weight_grams', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        nameDari,
        namePashto,
        nameEn,
        barcode,
        price,
        costPrice,
        stockQuantity,
        minStockAlert,
        unit,
        categoryId,
        imageUrl,
        expiryDate,
        prescriptionRequired,
        dosage,
        manufacturer,
        color,
        sizeVariant,
        imei,
        serialNumber,
        weightGrams,
        isActive,
        createdAt,
        updatedAt,
        syncStatus,
        syncedAt,
        localId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('name_dari')) {
      context.handle(_nameDariMeta,
          nameDari.isAcceptableOrUnknown(data['name_dari']!, _nameDariMeta));
    } else if (isInserting) {
      context.missing(_nameDariMeta);
    }
    if (data.containsKey('name_pashto')) {
      context.handle(
          _namePashtoMeta,
          namePashto.isAcceptableOrUnknown(
              data['name_pashto']!, _namePashtoMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
          _stockQuantityMeta,
          stockQuantity.isAcceptableOrUnknown(
              data['stock_quantity']!, _stockQuantityMeta));
    }
    if (data.containsKey('min_stock_alert')) {
      context.handle(
          _minStockAlertMeta,
          minStockAlert.isAcceptableOrUnknown(
              data['min_stock_alert']!, _minStockAlertMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('prescription_required')) {
      context.handle(
          _prescriptionRequiredMeta,
          prescriptionRequired.isAcceptableOrUnknown(
              data['prescription_required']!, _prescriptionRequiredMeta));
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('size_variant')) {
      context.handle(
          _sizeVariantMeta,
          sizeVariant.isAcceptableOrUnknown(
              data['size_variant']!, _sizeVariantMeta));
    }
    if (data.containsKey('imei')) {
      context.handle(
          _imeiMeta, imei.isAcceptableOrUnknown(data['imei']!, _imeiMeta));
    }
    if (data.containsKey('serial_number')) {
      context.handle(
          _serialNumberMeta,
          serialNumber.isAcceptableOrUnknown(
              data['serial_number']!, _serialNumberMeta));
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
          _weightGramsMeta,
          weightGrams.isAcceptableOrUnknown(
              data['weight_grams']!, _weightGramsMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      nameDari: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_dari'])!,
      namePashto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_pashto']),
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price']),
      stockQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_quantity'])!,
      minStockAlert: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}min_stock_alert'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      prescriptionRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}prescription_required'])!,
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage']),
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      sizeVariant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size_variant']),
      imei: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imei']),
      serialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_number']),
      weightGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_grams']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String shopId;
  final String nameDari;
  final String? namePashto;
  final String? nameEn;
  final String? barcode;
  final double price;
  final double? costPrice;
  final double stockQuantity;
  final double minStockAlert;
  final String unit;
  final String? categoryId;
  final String? imageUrl;
  final DateTime? expiryDate;
  final bool prescriptionRequired;
  final String? dosage;
  final String? manufacturer;
  final String? color;
  final String? sizeVariant;
  final String? imei;
  final String? serialNumber;
  final double? weightGrams;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  final String? localId;
  const Product(
      {required this.id,
      required this.shopId,
      required this.nameDari,
      this.namePashto,
      this.nameEn,
      this.barcode,
      required this.price,
      this.costPrice,
      required this.stockQuantity,
      required this.minStockAlert,
      required this.unit,
      this.categoryId,
      this.imageUrl,
      this.expiryDate,
      required this.prescriptionRequired,
      this.dosage,
      this.manufacturer,
      this.color,
      this.sizeVariant,
      this.imei,
      this.serialNumber,
      this.weightGrams,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.syncedAt,
      this.localId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['name_dari'] = Variable<String>(nameDari);
    if (!nullToAbsent || namePashto != null) {
      map['name_pashto'] = Variable<String>(namePashto);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || costPrice != null) {
      map['cost_price'] = Variable<double>(costPrice);
    }
    map['stock_quantity'] = Variable<double>(stockQuantity);
    map['min_stock_alert'] = Variable<double>(minStockAlert);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['prescription_required'] = Variable<bool>(prescriptionRequired);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || sizeVariant != null) {
      map['size_variant'] = Variable<String>(sizeVariant);
    }
    if (!nullToAbsent || imei != null) {
      map['imei'] = Variable<String>(imei);
    }
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    if (!nullToAbsent || weightGrams != null) {
      map['weight_grams'] = Variable<double>(weightGrams);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      shopId: Value(shopId),
      nameDari: Value(nameDari),
      namePashto: namePashto == null && nullToAbsent
          ? const Value.absent()
          : Value(namePashto),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      price: Value(price),
      costPrice: costPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(costPrice),
      stockQuantity: Value(stockQuantity),
      minStockAlert: Value(minStockAlert),
      unit: Value(unit),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      prescriptionRequired: Value(prescriptionRequired),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      sizeVariant: sizeVariant == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeVariant),
      imei: imei == null && nullToAbsent ? const Value.absent() : Value(imei),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      weightGrams: weightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGrams),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      nameDari: serializer.fromJson<String>(json['nameDari']),
      namePashto: serializer.fromJson<String?>(json['namePashto']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      price: serializer.fromJson<double>(json['price']),
      costPrice: serializer.fromJson<double?>(json['costPrice']),
      stockQuantity: serializer.fromJson<double>(json['stockQuantity']),
      minStockAlert: serializer.fromJson<double>(json['minStockAlert']),
      unit: serializer.fromJson<String>(json['unit']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      prescriptionRequired:
          serializer.fromJson<bool>(json['prescriptionRequired']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      color: serializer.fromJson<String?>(json['color']),
      sizeVariant: serializer.fromJson<String?>(json['sizeVariant']),
      imei: serializer.fromJson<String?>(json['imei']),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      weightGrams: serializer.fromJson<double?>(json['weightGrams']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      localId: serializer.fromJson<String?>(json['localId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'nameDari': serializer.toJson<String>(nameDari),
      'namePashto': serializer.toJson<String?>(namePashto),
      'nameEn': serializer.toJson<String?>(nameEn),
      'barcode': serializer.toJson<String?>(barcode),
      'price': serializer.toJson<double>(price),
      'costPrice': serializer.toJson<double?>(costPrice),
      'stockQuantity': serializer.toJson<double>(stockQuantity),
      'minStockAlert': serializer.toJson<double>(minStockAlert),
      'unit': serializer.toJson<String>(unit),
      'categoryId': serializer.toJson<String?>(categoryId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'prescriptionRequired': serializer.toJson<bool>(prescriptionRequired),
      'dosage': serializer.toJson<String?>(dosage),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'color': serializer.toJson<String?>(color),
      'sizeVariant': serializer.toJson<String?>(sizeVariant),
      'imei': serializer.toJson<String?>(imei),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'weightGrams': serializer.toJson<double?>(weightGrams),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'localId': serializer.toJson<String?>(localId),
    };
  }

  Product copyWith(
          {String? id,
          String? shopId,
          String? nameDari,
          Value<String?> namePashto = const Value.absent(),
          Value<String?> nameEn = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          double? price,
          Value<double?> costPrice = const Value.absent(),
          double? stockQuantity,
          double? minStockAlert,
          String? unit,
          Value<String?> categoryId = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          bool? prescriptionRequired,
          Value<String?> dosage = const Value.absent(),
          Value<String?> manufacturer = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> sizeVariant = const Value.absent(),
          Value<String?> imei = const Value.absent(),
          Value<String?> serialNumber = const Value.absent(),
          Value<double?> weightGrams = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<String?> localId = const Value.absent()}) =>
      Product(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        nameDari: nameDari ?? this.nameDari,
        namePashto: namePashto.present ? namePashto.value : this.namePashto,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        barcode: barcode.present ? barcode.value : this.barcode,
        price: price ?? this.price,
        costPrice: costPrice.present ? costPrice.value : this.costPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        minStockAlert: minStockAlert ?? this.minStockAlert,
        unit: unit ?? this.unit,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
        dosage: dosage.present ? dosage.value : this.dosage,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        color: color.present ? color.value : this.color,
        sizeVariant: sizeVariant.present ? sizeVariant.value : this.sizeVariant,
        imei: imei.present ? imei.value : this.imei,
        serialNumber:
            serialNumber.present ? serialNumber.value : this.serialNumber,
        weightGrams: weightGrams.present ? weightGrams.value : this.weightGrams,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        localId: localId.present ? localId.value : this.localId,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      nameDari: data.nameDari.present ? data.nameDari.value : this.nameDari,
      namePashto:
          data.namePashto.present ? data.namePashto.value : this.namePashto,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      price: data.price.present ? data.price.value : this.price,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      minStockAlert: data.minStockAlert.present
          ? data.minStockAlert.value
          : this.minStockAlert,
      unit: data.unit.present ? data.unit.value : this.unit,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      prescriptionRequired: data.prescriptionRequired.present
          ? data.prescriptionRequired.value
          : this.prescriptionRequired,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      color: data.color.present ? data.color.value : this.color,
      sizeVariant:
          data.sizeVariant.present ? data.sizeVariant.value : this.sizeVariant,
      imei: data.imei.present ? data.imei.value : this.imei,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      weightGrams:
          data.weightGrams.present ? data.weightGrams.value : this.weightGrams,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      localId: data.localId.present ? data.localId.value : this.localId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('nameDari: $nameDari, ')
          ..write('namePashto: $namePashto, ')
          ..write('nameEn: $nameEn, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('prescriptionRequired: $prescriptionRequired, ')
          ..write('dosage: $dosage, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('color: $color, ')
          ..write('sizeVariant: $sizeVariant, ')
          ..write('imei: $imei, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localId: $localId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        shopId,
        nameDari,
        namePashto,
        nameEn,
        barcode,
        price,
        costPrice,
        stockQuantity,
        minStockAlert,
        unit,
        categoryId,
        imageUrl,
        expiryDate,
        prescriptionRequired,
        dosage,
        manufacturer,
        color,
        sizeVariant,
        imei,
        serialNumber,
        weightGrams,
        isActive,
        createdAt,
        updatedAt,
        syncStatus,
        syncedAt,
        localId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.nameDari == this.nameDari &&
          other.namePashto == this.namePashto &&
          other.nameEn == this.nameEn &&
          other.barcode == this.barcode &&
          other.price == this.price &&
          other.costPrice == this.costPrice &&
          other.stockQuantity == this.stockQuantity &&
          other.minStockAlert == this.minStockAlert &&
          other.unit == this.unit &&
          other.categoryId == this.categoryId &&
          other.imageUrl == this.imageUrl &&
          other.expiryDate == this.expiryDate &&
          other.prescriptionRequired == this.prescriptionRequired &&
          other.dosage == this.dosage &&
          other.manufacturer == this.manufacturer &&
          other.color == this.color &&
          other.sizeVariant == this.sizeVariant &&
          other.imei == this.imei &&
          other.serialNumber == this.serialNumber &&
          other.weightGrams == this.weightGrams &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt &&
          other.localId == this.localId);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> nameDari;
  final Value<String?> namePashto;
  final Value<String?> nameEn;
  final Value<String?> barcode;
  final Value<double> price;
  final Value<double?> costPrice;
  final Value<double> stockQuantity;
  final Value<double> minStockAlert;
  final Value<String> unit;
  final Value<String?> categoryId;
  final Value<String?> imageUrl;
  final Value<DateTime?> expiryDate;
  final Value<bool> prescriptionRequired;
  final Value<String?> dosage;
  final Value<String?> manufacturer;
  final Value<String?> color;
  final Value<String?> sizeVariant;
  final Value<String?> imei;
  final Value<String?> serialNumber;
  final Value<double?> weightGrams;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<String?> localId;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.nameDari = const Value.absent(),
    this.namePashto = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.minStockAlert = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.prescriptionRequired = const Value.absent(),
    this.dosage = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.color = const Value.absent(),
    this.sizeVariant = const Value.absent(),
    this.imei = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String nameDari,
    this.namePashto = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.barcode = const Value.absent(),
    this.price = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.minStockAlert = const Value.absent(),
    this.unit = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.prescriptionRequired = const Value.absent(),
    this.dosage = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.color = const Value.absent(),
    this.sizeVariant = const Value.absent(),
    this.imei = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        nameDari = Value(nameDari);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? nameDari,
    Expression<String>? namePashto,
    Expression<String>? nameEn,
    Expression<String>? barcode,
    Expression<double>? price,
    Expression<double>? costPrice,
    Expression<double>? stockQuantity,
    Expression<double>? minStockAlert,
    Expression<String>? unit,
    Expression<String>? categoryId,
    Expression<String>? imageUrl,
    Expression<DateTime>? expiryDate,
    Expression<bool>? prescriptionRequired,
    Expression<String>? dosage,
    Expression<String>? manufacturer,
    Expression<String>? color,
    Expression<String>? sizeVariant,
    Expression<String>? imei,
    Expression<String>? serialNumber,
    Expression<double>? weightGrams,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<String>? localId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (nameDari != null) 'name_dari': nameDari,
      if (namePashto != null) 'name_pashto': namePashto,
      if (nameEn != null) 'name_en': nameEn,
      if (barcode != null) 'barcode': barcode,
      if (price != null) 'price': price,
      if (costPrice != null) 'cost_price': costPrice,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (minStockAlert != null) 'min_stock_alert': minStockAlert,
      if (unit != null) 'unit': unit,
      if (categoryId != null) 'category_id': categoryId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (prescriptionRequired != null)
        'prescription_required': prescriptionRequired,
      if (dosage != null) 'dosage': dosage,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (color != null) 'color': color,
      if (sizeVariant != null) 'size_variant': sizeVariant,
      if (imei != null) 'imei': imei,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (localId != null) 'local_id': localId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? nameDari,
      Value<String?>? namePashto,
      Value<String?>? nameEn,
      Value<String?>? barcode,
      Value<double>? price,
      Value<double?>? costPrice,
      Value<double>? stockQuantity,
      Value<double>? minStockAlert,
      Value<String>? unit,
      Value<String?>? categoryId,
      Value<String?>? imageUrl,
      Value<DateTime?>? expiryDate,
      Value<bool>? prescriptionRequired,
      Value<String?>? dosage,
      Value<String?>? manufacturer,
      Value<String?>? color,
      Value<String?>? sizeVariant,
      Value<String?>? imei,
      Value<String?>? serialNumber,
      Value<double?>? weightGrams,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<String?>? localId,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      nameDari: nameDari ?? this.nameDari,
      namePashto: namePashto ?? this.namePashto,
      nameEn: nameEn ?? this.nameEn,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      unit: unit ?? this.unit,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      expiryDate: expiryDate ?? this.expiryDate,
      prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
      dosage: dosage ?? this.dosage,
      manufacturer: manufacturer ?? this.manufacturer,
      color: color ?? this.color,
      sizeVariant: sizeVariant ?? this.sizeVariant,
      imei: imei ?? this.imei,
      serialNumber: serialNumber ?? this.serialNumber,
      weightGrams: weightGrams ?? this.weightGrams,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      localId: localId ?? this.localId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (nameDari.present) {
      map['name_dari'] = Variable<String>(nameDari.value);
    }
    if (namePashto.present) {
      map['name_pashto'] = Variable<String>(namePashto.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<double>(stockQuantity.value);
    }
    if (minStockAlert.present) {
      map['min_stock_alert'] = Variable<double>(minStockAlert.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (prescriptionRequired.present) {
      map['prescription_required'] = Variable<bool>(prescriptionRequired.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sizeVariant.present) {
      map['size_variant'] = Variable<String>(sizeVariant.value);
    }
    if (imei.present) {
      map['imei'] = Variable<String>(imei.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('nameDari: $nameDari, ')
          ..write('namePashto: $namePashto, ')
          ..write('nameEn: $nameEn, ')
          ..write('barcode: $barcode, ')
          ..write('price: $price, ')
          ..write('costPrice: $costPrice, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('unit: $unit, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('prescriptionRequired: $prescriptionRequired, ')
          ..write('dosage: $dosage, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('color: $color, ')
          ..write('sizeVariant: $sizeVariant, ')
          ..write('imei: $imei, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localId: $localId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_cust_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalOwedMeta =
      const VerificationMeta('totalOwed');
  @override
  late final GeneratedColumn<double> totalOwed = GeneratedColumn<double>(
      'total_owed', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastInteractionAtMeta =
      const VerificationMeta('lastInteractionAt');
  @override
  late final GeneratedColumn<DateTime> lastInteractionAt =
      GeneratedColumn<DateTime>('last_interaction_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        name,
        phone,
        totalOwed,
        notes,
        lastInteractionAt,
        createdAt,
        updatedAt,
        syncStatus,
        syncedAt,
        localId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('total_owed')) {
      context.handle(_totalOwedMeta,
          totalOwed.isAcceptableOrUnknown(data['total_owed']!, _totalOwedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('last_interaction_at')) {
      context.handle(
          _lastInteractionAtMeta,
          lastInteractionAt.isAcceptableOrUnknown(
              data['last_interaction_at']!, _lastInteractionAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      totalOwed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_owed'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      lastInteractionAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_interaction_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String shopId;
  final String name;
  final String? phone;
  final double totalOwed;
  final String? notes;
  final DateTime? lastInteractionAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  final String? localId;
  const Customer(
      {required this.id,
      required this.shopId,
      required this.name,
      this.phone,
      required this.totalOwed,
      this.notes,
      this.lastInteractionAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.syncedAt,
      this.localId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['total_owed'] = Variable<double>(totalOwed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || lastInteractionAt != null) {
      map['last_interaction_at'] = Variable<DateTime>(lastInteractionAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      shopId: Value(shopId),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      totalOwed: Value(totalOwed),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      lastInteractionAt: lastInteractionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInteractionAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      totalOwed: serializer.fromJson<double>(json['totalOwed']),
      notes: serializer.fromJson<String?>(json['notes']),
      lastInteractionAt:
          serializer.fromJson<DateTime?>(json['lastInteractionAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      localId: serializer.fromJson<String?>(json['localId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'totalOwed': serializer.toJson<double>(totalOwed),
      'notes': serializer.toJson<String?>(notes),
      'lastInteractionAt': serializer.toJson<DateTime?>(lastInteractionAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'localId': serializer.toJson<String?>(localId),
    };
  }

  Customer copyWith(
          {String? id,
          String? shopId,
          String? name,
          Value<String?> phone = const Value.absent(),
          double? totalOwed,
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> lastInteractionAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<String?> localId = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        totalOwed: totalOwed ?? this.totalOwed,
        notes: notes.present ? notes.value : this.notes,
        lastInteractionAt: lastInteractionAt.present
            ? lastInteractionAt.value
            : this.lastInteractionAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        localId: localId.present ? localId.value : this.localId,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      totalOwed: data.totalOwed.present ? data.totalOwed.value : this.totalOwed,
      notes: data.notes.present ? data.notes.value : this.notes,
      lastInteractionAt: data.lastInteractionAt.present
          ? data.lastInteractionAt.value
          : this.lastInteractionAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      localId: data.localId.present ? data.localId.value : this.localId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('totalOwed: $totalOwed, ')
          ..write('notes: $notes, ')
          ..write('lastInteractionAt: $lastInteractionAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localId: $localId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shopId, name, phone, totalOwed, notes,
      lastInteractionAt, createdAt, updatedAt, syncStatus, syncedAt, localId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.totalOwed == this.totalOwed &&
          other.notes == this.notes &&
          other.lastInteractionAt == this.lastInteractionAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt &&
          other.localId == this.localId);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<double> totalOwed;
  final Value<String?> notes;
  final Value<DateTime?> lastInteractionAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<String?> localId;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.totalOwed = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastInteractionAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String name,
    this.phone = const Value.absent(),
    this.totalOwed = const Value.absent(),
    this.notes = const Value.absent(),
    this.lastInteractionAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        name = Value(name);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<double>? totalOwed,
    Expression<String>? notes,
    Expression<DateTime>? lastInteractionAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<String>? localId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (totalOwed != null) 'total_owed': totalOwed,
      if (notes != null) 'notes': notes,
      if (lastInteractionAt != null) 'last_interaction_at': lastInteractionAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (localId != null) 'local_id': localId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? name,
      Value<String?>? phone,
      Value<double>? totalOwed,
      Value<String?>? notes,
      Value<DateTime?>? lastInteractionAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<String?>? localId,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalOwed: totalOwed ?? this.totalOwed,
      notes: notes ?? this.notes,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      localId: localId ?? this.localId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (totalOwed.present) {
      map['total_owed'] = Variable<double>(totalOwed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (lastInteractionAt.present) {
      map['last_interaction_at'] = Variable<DateTime>(lastInteractionAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('totalOwed: $totalOwed, ')
          ..write('notes: $notes, ')
          ..write('lastInteractionAt: $lastInteractionAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('localId: $localId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_sale_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalAfnMeta =
      const VerificationMeta('totalAfn');
  @override
  late final GeneratedColumn<double> totalAfn = GeneratedColumn<double>(
      'total_afn', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('AFN'));
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _isCreditMeta =
      const VerificationMeta('isCredit');
  @override
  late final GeneratedColumn<bool> isCredit = GeneratedColumn<bool>(
      'is_credit', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_credit" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdOfflineMeta =
      const VerificationMeta('createdOffline');
  @override
  late final GeneratedColumn<bool> createdOffline = GeneratedColumn<bool>(
      'created_offline', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("created_offline" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        customerId,
        totalAmount,
        totalAfn,
        discount,
        paymentMethod,
        currency,
        exchangeRate,
        isCredit,
        note,
        createdOffline,
        localId,
        syncedAt,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_afn')) {
      context.handle(_totalAfnMeta,
          totalAfn.isAcceptableOrUnknown(data['total_afn']!, _totalAfnMeta));
    } else if (isInserting) {
      context.missing(_totalAfnMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('is_credit')) {
      context.handle(_isCreditMeta,
          isCredit.isAcceptableOrUnknown(data['is_credit']!, _isCreditMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_offline')) {
      context.handle(
          _createdOfflineMeta,
          createdOffline.isAcceptableOrUnknown(
              data['created_offline']!, _createdOfflineMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      totalAfn: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_afn'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate'])!,
      isCredit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_credit'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdOffline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}created_offline'])!,
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String shopId;
  final String? customerId;
  final double totalAmount;
  final double totalAfn;
  final double discount;
  final String paymentMethod;
  final String currency;
  final double exchangeRate;
  final bool isCredit;
  final String? note;
  final bool createdOffline;
  final String? localId;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const Sale(
      {required this.id,
      required this.shopId,
      this.customerId,
      required this.totalAmount,
      required this.totalAfn,
      required this.discount,
      required this.paymentMethod,
      required this.currency,
      required this.exchangeRate,
      required this.isCredit,
      this.note,
      required this.createdOffline,
      this.localId,
      this.syncedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_afn'] = Variable<double>(totalAfn);
    map['discount'] = Variable<double>(discount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['currency'] = Variable<String>(currency);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['is_credit'] = Variable<bool>(isCredit);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_offline'] = Variable<bool>(createdOffline);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      shopId: Value(shopId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      totalAmount: Value(totalAmount),
      totalAfn: Value(totalAfn),
      discount: Value(discount),
      paymentMethod: Value(paymentMethod),
      currency: Value(currency),
      exchangeRate: Value(exchangeRate),
      isCredit: Value(isCredit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdOffline: Value(createdOffline),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalAfn: serializer.fromJson<double>(json['totalAfn']),
      discount: serializer.fromJson<double>(json['discount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      isCredit: serializer.fromJson<bool>(json['isCredit']),
      note: serializer.fromJson<String?>(json['note']),
      createdOffline: serializer.fromJson<bool>(json['createdOffline']),
      localId: serializer.fromJson<String?>(json['localId']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'customerId': serializer.toJson<String?>(customerId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalAfn': serializer.toJson<double>(totalAfn),
      'discount': serializer.toJson<double>(discount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'isCredit': serializer.toJson<bool>(isCredit),
      'note': serializer.toJson<String?>(note),
      'createdOffline': serializer.toJson<bool>(createdOffline),
      'localId': serializer.toJson<String?>(localId),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Sale copyWith(
          {String? id,
          String? shopId,
          Value<String?> customerId = const Value.absent(),
          double? totalAmount,
          double? totalAfn,
          double? discount,
          String? paymentMethod,
          String? currency,
          double? exchangeRate,
          bool? isCredit,
          Value<String?> note = const Value.absent(),
          bool? createdOffline,
          Value<String?> localId = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      Sale(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        customerId: customerId.present ? customerId.value : this.customerId,
        totalAmount: totalAmount ?? this.totalAmount,
        totalAfn: totalAfn ?? this.totalAfn,
        discount: discount ?? this.discount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        currency: currency ?? this.currency,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        isCredit: isCredit ?? this.isCredit,
        note: note.present ? note.value : this.note,
        createdOffline: createdOffline ?? this.createdOffline,
        localId: localId.present ? localId.value : this.localId,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      totalAfn: data.totalAfn.present ? data.totalAfn.value : this.totalAfn,
      discount: data.discount.present ? data.discount.value : this.discount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      isCredit: data.isCredit.present ? data.isCredit.value : this.isCredit,
      note: data.note.present ? data.note.value : this.note,
      createdOffline: data.createdOffline.present
          ? data.createdOffline.value
          : this.createdOffline,
      localId: data.localId.present ? data.localId.value : this.localId,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAfn: $totalAfn, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isCredit: $isCredit, ')
          ..write('note: $note, ')
          ..write('createdOffline: $createdOffline, ')
          ..write('localId: $localId, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shopId,
      customerId,
      totalAmount,
      totalAfn,
      discount,
      paymentMethod,
      currency,
      exchangeRate,
      isCredit,
      note,
      createdOffline,
      localId,
      syncedAt,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.customerId == this.customerId &&
          other.totalAmount == this.totalAmount &&
          other.totalAfn == this.totalAfn &&
          other.discount == this.discount &&
          other.paymentMethod == this.paymentMethod &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.isCredit == this.isCredit &&
          other.note == this.note &&
          other.createdOffline == this.createdOffline &&
          other.localId == this.localId &&
          other.syncedAt == this.syncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String?> customerId;
  final Value<double> totalAmount;
  final Value<double> totalAfn;
  final Value<double> discount;
  final Value<String> paymentMethod;
  final Value<String> currency;
  final Value<double> exchangeRate;
  final Value<bool> isCredit;
  final Value<String?> note;
  final Value<bool> createdOffline;
  final Value<String?> localId;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalAfn = const Value.absent(),
    this.discount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.isCredit = const Value.absent(),
    this.note = const Value.absent(),
    this.createdOffline = const Value.absent(),
    this.localId = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    this.customerId = const Value.absent(),
    required double totalAmount,
    required double totalAfn,
    this.discount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.isCredit = const Value.absent(),
    this.note = const Value.absent(),
    this.createdOffline = const Value.absent(),
    this.localId = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        totalAmount = Value(totalAmount),
        totalAfn = Value(totalAfn);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? customerId,
    Expression<double>? totalAmount,
    Expression<double>? totalAfn,
    Expression<double>? discount,
    Expression<String>? paymentMethod,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<bool>? isCredit,
    Expression<String>? note,
    Expression<bool>? createdOffline,
    Expression<String>? localId,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (customerId != null) 'customer_id': customerId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalAfn != null) 'total_afn': totalAfn,
      if (discount != null) 'discount': discount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (isCredit != null) 'is_credit': isCredit,
      if (note != null) 'note': note,
      if (createdOffline != null) 'created_offline': createdOffline,
      if (localId != null) 'local_id': localId,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String?>? customerId,
      Value<double>? totalAmount,
      Value<double>? totalAfn,
      Value<double>? discount,
      Value<String>? paymentMethod,
      Value<String>? currency,
      Value<double>? exchangeRate,
      Value<bool>? isCredit,
      Value<String?>? note,
      Value<bool>? createdOffline,
      Value<String?>? localId,
      Value<DateTime?>? syncedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return SalesCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      customerId: customerId ?? this.customerId,
      totalAmount: totalAmount ?? this.totalAmount,
      totalAfn: totalAfn ?? this.totalAfn,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isCredit: isCredit ?? this.isCredit,
      note: note ?? this.note,
      createdOffline: createdOffline ?? this.createdOffline,
      localId: localId ?? this.localId,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalAfn.present) {
      map['total_afn'] = Variable<double>(totalAfn.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (isCredit.present) {
      map['is_credit'] = Variable<bool>(isCredit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdOffline.present) {
      map['created_offline'] = Variable<bool>(createdOffline.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAfn: $totalAfn, ')
          ..write('discount: $discount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isCredit: $isCredit, ')
          ..write('note: $note, ')
          ..write('createdOffline: $createdOffline, ')
          ..write('localId: $localId, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_item_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>('product_name_snapshot', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        productId,
        productNameSnapshot,
        quantity,
        unitPrice,
        subtotal,
        createdAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
          _productNameSnapshotMeta,
          productNameSnapshot.isAcceptableOrUnknown(
              data['product_name_snapshot']!, _productNameSnapshotMeta));
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      productNameSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product_name_snapshot'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final String saleId;
  final String? productId;
  final String productNameSnapshot;
  final double quantity;
  final double unitPrice;
  final double subtotal;
  final DateTime createdAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const SaleItem(
      {required this.id,
      required this.saleId,
      this.productId,
      required this.productNameSnapshot,
      required this.quantity,
      required this.unitPrice,
      required this.subtotal,
      required this.createdAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['subtotal'] = Variable<double>(subtotal);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productNameSnapshot: Value(productNameSnapshot),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      subtotal: Value(subtotal),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String?>(json['productId']),
      productNameSnapshot:
          serializer.fromJson<String>(json['productNameSnapshot']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String?>(productId),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'subtotal': serializer.toJson<double>(subtotal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SaleItem copyWith(
          {String? id,
          String? saleId,
          Value<String?> productId = const Value.absent(),
          String? productNameSnapshot,
          double? quantity,
          double? unitPrice,
          double? subtotal,
          DateTime? createdAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId.present ? productId.value : this.productId,
        productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        subtotal: subtotal ?? this.subtotal,
        createdAt: createdAt ?? this.createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saleId, productId, productNameSnapshot,
      quantity, unitPrice, subtotal, createdAt, syncStatus, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.subtotal == this.subtotal &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String?> productId;
  final Value<String> productNameSnapshot;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> subtotal;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required String saleId,
    this.productId = const Value.absent(),
    required String productNameSnapshot,
    required double quantity,
    required double unitPrice,
    required double subtotal,
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : saleId = Value(saleId),
        productNameSnapshot = Value(productNameSnapshot),
        quantity = Value(quantity),
        unitPrice = Value(unitPrice),
        subtotal = Value(subtotal);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productNameSnapshot,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? subtotal,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (subtotal != null) 'subtotal': subtotal,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String?>? productId,
      Value<String>? productNameSnapshot,
      Value<double>? quantity,
      Value<double>? unitPrice,
      Value<double>? subtotal,
      Value<DateTime>? createdAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] =
          Variable<String>(productNameSnapshot.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_debt_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountOriginalMeta =
      const VerificationMeta('amountOriginal');
  @override
  late final GeneratedColumn<double> amountOriginal = GeneratedColumn<double>(
      'amount_original', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountPaidMeta =
      const VerificationMeta('amountPaid');
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
      'amount_paid', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _amountRemainingMeta =
      const VerificationMeta('amountRemaining');
  @override
  late final GeneratedColumn<double> amountRemaining = GeneratedColumn<double>(
      'amount_remaining', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastReminderSentAtMeta =
      const VerificationMeta('lastReminderSentAt');
  @override
  late final GeneratedColumn<DateTime> lastReminderSentAt =
      GeneratedColumn<DateTime>('last_reminder_sent_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        customerId,
        saleId,
        amountOriginal,
        amountPaid,
        amountRemaining,
        status,
        dueDate,
        lastReminderSentAt,
        notes,
        createdAt,
        updatedAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    }
    if (data.containsKey('amount_original')) {
      context.handle(
          _amountOriginalMeta,
          amountOriginal.isAcceptableOrUnknown(
              data['amount_original']!, _amountOriginalMeta));
    } else if (isInserting) {
      context.missing(_amountOriginalMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
          _amountPaidMeta,
          amountPaid.isAcceptableOrUnknown(
              data['amount_paid']!, _amountPaidMeta));
    }
    if (data.containsKey('amount_remaining')) {
      context.handle(
          _amountRemainingMeta,
          amountRemaining.isAcceptableOrUnknown(
              data['amount_remaining']!, _amountRemainingMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('last_reminder_sent_at')) {
      context.handle(
          _lastReminderSentAtMeta,
          lastReminderSentAt.isAcceptableOrUnknown(
              data['last_reminder_sent_at']!, _lastReminderSentAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id']),
      amountOriginal: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_original'])!,
      amountPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_paid'])!,
      amountRemaining: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}amount_remaining'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      lastReminderSentAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_reminder_sent_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final String id;
  final String shopId;
  final String customerId;
  final String? saleId;
  final double amountOriginal;
  final double amountPaid;
  final double amountRemaining;
  final String status;
  final DateTime? dueDate;
  final DateTime? lastReminderSentAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const Debt(
      {required this.id,
      required this.shopId,
      required this.customerId,
      this.saleId,
      required this.amountOriginal,
      required this.amountPaid,
      required this.amountRemaining,
      required this.status,
      this.dueDate,
      this.lastReminderSentAt,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['customer_id'] = Variable<String>(customerId);
    if (!nullToAbsent || saleId != null) {
      map['sale_id'] = Variable<String>(saleId);
    }
    map['amount_original'] = Variable<double>(amountOriginal);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['amount_remaining'] = Variable<double>(amountRemaining);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || lastReminderSentAt != null) {
      map['last_reminder_sent_at'] = Variable<DateTime>(lastReminderSentAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      shopId: Value(shopId),
      customerId: Value(customerId),
      saleId:
          saleId == null && nullToAbsent ? const Value.absent() : Value(saleId),
      amountOriginal: Value(amountOriginal),
      amountPaid: Value(amountPaid),
      amountRemaining: Value(amountRemaining),
      status: Value(status),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      lastReminderSentAt: lastReminderSentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReminderSentAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      saleId: serializer.fromJson<String?>(json['saleId']),
      amountOriginal: serializer.fromJson<double>(json['amountOriginal']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      amountRemaining: serializer.fromJson<double>(json['amountRemaining']),
      status: serializer.fromJson<String>(json['status']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      lastReminderSentAt:
          serializer.fromJson<DateTime?>(json['lastReminderSentAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'customerId': serializer.toJson<String>(customerId),
      'saleId': serializer.toJson<String?>(saleId),
      'amountOriginal': serializer.toJson<double>(amountOriginal),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'amountRemaining': serializer.toJson<double>(amountRemaining),
      'status': serializer.toJson<String>(status),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'lastReminderSentAt': serializer.toJson<DateTime?>(lastReminderSentAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Debt copyWith(
          {String? id,
          String? shopId,
          String? customerId,
          Value<String?> saleId = const Value.absent(),
          double? amountOriginal,
          double? amountPaid,
          double? amountRemaining,
          String? status,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<DateTime?> lastReminderSentAt = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      Debt(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        customerId: customerId ?? this.customerId,
        saleId: saleId.present ? saleId.value : this.saleId,
        amountOriginal: amountOriginal ?? this.amountOriginal,
        amountPaid: amountPaid ?? this.amountPaid,
        amountRemaining: amountRemaining ?? this.amountRemaining,
        status: status ?? this.status,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        lastReminderSentAt: lastReminderSentAt.present
            ? lastReminderSentAt.value
            : this.lastReminderSentAt,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      amountOriginal: data.amountOriginal.present
          ? data.amountOriginal.value
          : this.amountOriginal,
      amountPaid:
          data.amountPaid.present ? data.amountPaid.value : this.amountPaid,
      amountRemaining: data.amountRemaining.present
          ? data.amountRemaining.value
          : this.amountRemaining,
      status: data.status.present ? data.status.value : this.status,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      lastReminderSentAt: data.lastReminderSentAt.present
          ? data.lastReminderSentAt.value
          : this.lastReminderSentAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('customerId: $customerId, ')
          ..write('saleId: $saleId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('amountRemaining: $amountRemaining, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('lastReminderSentAt: $lastReminderSentAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shopId,
      customerId,
      saleId,
      amountOriginal,
      amountPaid,
      amountRemaining,
      status,
      dueDate,
      lastReminderSentAt,
      notes,
      createdAt,
      updatedAt,
      syncStatus,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.customerId == this.customerId &&
          other.saleId == this.saleId &&
          other.amountOriginal == this.amountOriginal &&
          other.amountPaid == this.amountPaid &&
          other.amountRemaining == this.amountRemaining &&
          other.status == this.status &&
          other.dueDate == this.dueDate &&
          other.lastReminderSentAt == this.lastReminderSentAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> customerId;
  final Value<String?> saleId;
  final Value<double> amountOriginal;
  final Value<double> amountPaid;
  final Value<double> amountRemaining;
  final Value<String> status;
  final Value<DateTime?> dueDate;
  final Value<DateTime?> lastReminderSentAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.amountOriginal = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.amountRemaining = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.lastReminderSentAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String customerId,
    this.saleId = const Value.absent(),
    required double amountOriginal,
    this.amountPaid = const Value.absent(),
    this.amountRemaining = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.lastReminderSentAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        customerId = Value(customerId),
        amountOriginal = Value(amountOriginal);
  static Insertable<Debt> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? customerId,
    Expression<String>? saleId,
    Expression<double>? amountOriginal,
    Expression<double>? amountPaid,
    Expression<double>? amountRemaining,
    Expression<String>? status,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? lastReminderSentAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (customerId != null) 'customer_id': customerId,
      if (saleId != null) 'sale_id': saleId,
      if (amountOriginal != null) 'amount_original': amountOriginal,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (amountRemaining != null) 'amount_remaining': amountRemaining,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (lastReminderSentAt != null)
        'last_reminder_sent_at': lastReminderSentAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtsCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? customerId,
      Value<String?>? saleId,
      Value<double>? amountOriginal,
      Value<double>? amountPaid,
      Value<double>? amountRemaining,
      Value<String>? status,
      Value<DateTime?>? dueDate,
      Value<DateTime?>? lastReminderSentAt,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return DebtsCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      customerId: customerId ?? this.customerId,
      saleId: saleId ?? this.saleId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      amountPaid: amountPaid ?? this.amountPaid,
      amountRemaining: amountRemaining ?? this.amountRemaining,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      lastReminderSentAt: lastReminderSentAt ?? this.lastReminderSentAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (amountOriginal.present) {
      map['amount_original'] = Variable<double>(amountOriginal.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (amountRemaining.present) {
      map['amount_remaining'] = Variable<double>(amountRemaining.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (lastReminderSentAt.present) {
      map['last_reminder_sent_at'] =
          Variable<DateTime>(lastReminderSentAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('customerId: $customerId, ')
          ..write('saleId: $saleId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('amountRemaining: $amountRemaining, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('lastReminderSentAt: $lastReminderSentAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtPaymentsTable extends DebtPayments
    with TableInfo<$DebtPaymentsTable, DebtPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_pay_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<String> debtId = GeneratedColumn<String>(
      'debt_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('AFN'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        debtId,
        shopId,
        amount,
        paymentMethod,
        currency,
        notes,
        createdAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_payments';
  @override
  VerificationContext validateIntegrity(Insertable<DebtPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    } else if (isInserting) {
      context.missing(_debtIdMeta);
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}debt_id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $DebtPaymentsTable createAlias(String alias) {
    return $DebtPaymentsTable(attachedDatabase, alias);
  }
}

class DebtPayment extends DataClass implements Insertable<DebtPayment> {
  final String id;
  final String debtId;
  final String shopId;
  final double amount;
  final String paymentMethod;
  final String currency;
  final String? notes;
  final DateTime createdAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const DebtPayment(
      {required this.id,
      required this.debtId,
      required this.shopId,
      required this.amount,
      required this.paymentMethod,
      required this.currency,
      this.notes,
      required this.createdAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['debt_id'] = Variable<String>(debtId);
    map['shop_id'] = Variable<String>(shopId);
    map['amount'] = Variable<double>(amount);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  DebtPaymentsCompanion toCompanion(bool nullToAbsent) {
    return DebtPaymentsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      shopId: Value(shopId),
      amount: Value(amount),
      paymentMethod: Value(paymentMethod),
      currency: Value(currency),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory DebtPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtPayment(
      id: serializer.fromJson<String>(json['id']),
      debtId: serializer.fromJson<String>(json['debtId']),
      shopId: serializer.fromJson<String>(json['shopId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'debtId': serializer.toJson<String>(debtId),
      'shopId': serializer.toJson<String>(shopId),
      'amount': serializer.toJson<double>(amount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  DebtPayment copyWith(
          {String? id,
          String? debtId,
          String? shopId,
          double? amount,
          String? paymentMethod,
          String? currency,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      DebtPayment(
        id: id ?? this.id,
        debtId: debtId ?? this.debtId,
        shopId: shopId ?? this.shopId,
        amount: amount ?? this.amount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        currency: currency ?? this.currency,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  DebtPayment copyWithCompanion(DebtPaymentsCompanion data) {
    return DebtPayment(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtPayment(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('shopId: $shopId, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, debtId, shopId, amount, paymentMethod,
      currency, notes, createdAt, syncStatus, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtPayment &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.shopId == this.shopId &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class DebtPaymentsCompanion extends UpdateCompanion<DebtPayment> {
  final Value<String> id;
  final Value<String> debtId;
  final Value<String> shopId;
  final Value<double> amount;
  final Value<String> paymentMethod;
  final Value<String> currency;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const DebtPaymentsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.shopId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String debtId,
    required String shopId,
    required double amount,
    this.paymentMethod = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : debtId = Value(debtId),
        shopId = Value(shopId),
        amount = Value(amount);
  static Insertable<DebtPayment> custom({
    Expression<String>? id,
    Expression<String>? debtId,
    Expression<String>? shopId,
    Expression<double>? amount,
    Expression<String>? paymentMethod,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (shopId != null) 'shop_id': shopId,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? debtId,
      Value<String>? shopId,
      Value<double>? amount,
      Value<String>? paymentMethod,
      Value<String>? currency,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return DebtPaymentsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      shopId: shopId ?? this.shopId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<String>(debtId.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('shopId: $shopId, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryAdjustmentsTable extends InventoryAdjustments
    with TableInfo<$InventoryAdjustmentsTable, InventoryAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_adj_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityBeforeMeta =
      const VerificationMeta('quantityBefore');
  @override
  late final GeneratedColumn<double> quantityBefore = GeneratedColumn<double>(
      'quantity_before', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityAfterMeta =
      const VerificationMeta('quantityAfter');
  @override
  late final GeneratedColumn<double> quantityAfter = GeneratedColumn<double>(
      'quantity_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityChangeMeta =
      const VerificationMeta('quantityChange');
  @override
  late final GeneratedColumn<double> quantityChange = GeneratedColumn<double>(
      'quantity_change', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adjustedAtMeta =
      const VerificationMeta('adjustedAt');
  @override
  late final GeneratedColumn<DateTime> adjustedAt = GeneratedColumn<DateTime>(
      'adjusted_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        productId,
        quantityBefore,
        quantityAfter,
        quantityChange,
        reason,
        notes,
        adjustedAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_adjustments';
  @override
  VerificationContext validateIntegrity(
      Insertable<InventoryAdjustment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_before')) {
      context.handle(
          _quantityBeforeMeta,
          quantityBefore.isAcceptableOrUnknown(
              data['quantity_before']!, _quantityBeforeMeta));
    } else if (isInserting) {
      context.missing(_quantityBeforeMeta);
    }
    if (data.containsKey('quantity_after')) {
      context.handle(
          _quantityAfterMeta,
          quantityAfter.isAcceptableOrUnknown(
              data['quantity_after']!, _quantityAfterMeta));
    } else if (isInserting) {
      context.missing(_quantityAfterMeta);
    }
    if (data.containsKey('quantity_change')) {
      context.handle(
          _quantityChangeMeta,
          quantityChange.isAcceptableOrUnknown(
              data['quantity_change']!, _quantityChangeMeta));
    } else if (isInserting) {
      context.missing(_quantityChangeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('adjusted_at')) {
      context.handle(
          _adjustedAtMeta,
          adjustedAt.isAcceptableOrUnknown(
              data['adjusted_at']!, _adjustedAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryAdjustment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_before'])!,
      quantityAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity_after'])!,
      quantityChange: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_change'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      adjustedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}adjusted_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $InventoryAdjustmentsTable createAlias(String alias) {
    return $InventoryAdjustmentsTable(attachedDatabase, alias);
  }
}

class InventoryAdjustment extends DataClass
    implements Insertable<InventoryAdjustment> {
  final String id;
  final String shopId;
  final String productId;
  final double quantityBefore;
  final double quantityAfter;
  final double quantityChange;
  final String reason;
  final String? notes;
  final DateTime adjustedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const InventoryAdjustment(
      {required this.id,
      required this.shopId,
      required this.productId,
      required this.quantityBefore,
      required this.quantityAfter,
      required this.quantityChange,
      required this.reason,
      this.notes,
      required this.adjustedAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_before'] = Variable<double>(quantityBefore);
    map['quantity_after'] = Variable<double>(quantityAfter);
    map['quantity_change'] = Variable<double>(quantityChange);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['adjusted_at'] = Variable<DateTime>(adjustedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  InventoryAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return InventoryAdjustmentsCompanion(
      id: Value(id),
      shopId: Value(shopId),
      productId: Value(productId),
      quantityBefore: Value(quantityBefore),
      quantityAfter: Value(quantityAfter),
      quantityChange: Value(quantityChange),
      reason: Value(reason),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      adjustedAt: Value(adjustedAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory InventoryAdjustment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryAdjustment(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityBefore: serializer.fromJson<double>(json['quantityBefore']),
      quantityAfter: serializer.fromJson<double>(json['quantityAfter']),
      quantityChange: serializer.fromJson<double>(json['quantityChange']),
      reason: serializer.fromJson<String>(json['reason']),
      notes: serializer.fromJson<String?>(json['notes']),
      adjustedAt: serializer.fromJson<DateTime>(json['adjustedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'productId': serializer.toJson<String>(productId),
      'quantityBefore': serializer.toJson<double>(quantityBefore),
      'quantityAfter': serializer.toJson<double>(quantityAfter),
      'quantityChange': serializer.toJson<double>(quantityChange),
      'reason': serializer.toJson<String>(reason),
      'notes': serializer.toJson<String?>(notes),
      'adjustedAt': serializer.toJson<DateTime>(adjustedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  InventoryAdjustment copyWith(
          {String? id,
          String? shopId,
          String? productId,
          double? quantityBefore,
          double? quantityAfter,
          double? quantityChange,
          String? reason,
          Value<String?> notes = const Value.absent(),
          DateTime? adjustedAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      InventoryAdjustment(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        productId: productId ?? this.productId,
        quantityBefore: quantityBefore ?? this.quantityBefore,
        quantityAfter: quantityAfter ?? this.quantityAfter,
        quantityChange: quantityChange ?? this.quantityChange,
        reason: reason ?? this.reason,
        notes: notes.present ? notes.value : this.notes,
        adjustedAt: adjustedAt ?? this.adjustedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  InventoryAdjustment copyWithCompanion(InventoryAdjustmentsCompanion data) {
    return InventoryAdjustment(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityBefore: data.quantityBefore.present
          ? data.quantityBefore.value
          : this.quantityBefore,
      quantityAfter: data.quantityAfter.present
          ? data.quantityAfter.value
          : this.quantityAfter,
      quantityChange: data.quantityChange.present
          ? data.quantityChange.value
          : this.quantityChange,
      reason: data.reason.present ? data.reason.value : this.reason,
      notes: data.notes.present ? data.notes.value : this.notes,
      adjustedAt:
          data.adjustedAt.present ? data.adjustedAt.value : this.adjustedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustment(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('productId: $productId, ')
          ..write('quantityBefore: $quantityBefore, ')
          ..write('quantityAfter: $quantityAfter, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('adjustedAt: $adjustedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      shopId,
      productId,
      quantityBefore,
      quantityAfter,
      quantityChange,
      reason,
      notes,
      adjustedAt,
      syncStatus,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryAdjustment &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.productId == this.productId &&
          other.quantityBefore == this.quantityBefore &&
          other.quantityAfter == this.quantityAfter &&
          other.quantityChange == this.quantityChange &&
          other.reason == this.reason &&
          other.notes == this.notes &&
          other.adjustedAt == this.adjustedAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class InventoryAdjustmentsCompanion
    extends UpdateCompanion<InventoryAdjustment> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> productId;
  final Value<double> quantityBefore;
  final Value<double> quantityAfter;
  final Value<double> quantityChange;
  final Value<String> reason;
  final Value<String?> notes;
  final Value<DateTime> adjustedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const InventoryAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityBefore = const Value.absent(),
    this.quantityAfter = const Value.absent(),
    this.quantityChange = const Value.absent(),
    this.reason = const Value.absent(),
    this.notes = const Value.absent(),
    this.adjustedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryAdjustmentsCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String productId,
    required double quantityBefore,
    required double quantityAfter,
    required double quantityChange,
    required String reason,
    this.notes = const Value.absent(),
    this.adjustedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        productId = Value(productId),
        quantityBefore = Value(quantityBefore),
        quantityAfter = Value(quantityAfter),
        quantityChange = Value(quantityChange),
        reason = Value(reason);
  static Insertable<InventoryAdjustment> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? productId,
    Expression<double>? quantityBefore,
    Expression<double>? quantityAfter,
    Expression<double>? quantityChange,
    Expression<String>? reason,
    Expression<String>? notes,
    Expression<DateTime>? adjustedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (productId != null) 'product_id': productId,
      if (quantityBefore != null) 'quantity_before': quantityBefore,
      if (quantityAfter != null) 'quantity_after': quantityAfter,
      if (quantityChange != null) 'quantity_change': quantityChange,
      if (reason != null) 'reason': reason,
      if (notes != null) 'notes': notes,
      if (adjustedAt != null) 'adjusted_at': adjustedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryAdjustmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? productId,
      Value<double>? quantityBefore,
      Value<double>? quantityAfter,
      Value<double>? quantityChange,
      Value<String>? reason,
      Value<String?>? notes,
      Value<DateTime>? adjustedAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return InventoryAdjustmentsCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      productId: productId ?? this.productId,
      quantityBefore: quantityBefore ?? this.quantityBefore,
      quantityAfter: quantityAfter ?? this.quantityAfter,
      quantityChange: quantityChange ?? this.quantityChange,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      adjustedAt: adjustedAt ?? this.adjustedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityBefore.present) {
      map['quantity_before'] = Variable<double>(quantityBefore.value);
    }
    if (quantityAfter.present) {
      map['quantity_after'] = Variable<double>(quantityAfter.value);
    }
    if (quantityChange.present) {
      map['quantity_change'] = Variable<double>(quantityChange.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (adjustedAt.present) {
      map['adjusted_at'] = Variable<DateTime>(adjustedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('productId: $productId, ')
          ..write('quantityBefore: $quantityBefore, ')
          ..write('quantityAfter: $quantityAfter, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('reason: $reason, ')
          ..write('notes: $notes, ')
          ..write('adjustedAt: $adjustedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_cat_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameDariMeta =
      const VerificationMeta('nameDari');
  @override
  late final GeneratedColumn<String> nameDari = GeneratedColumn<String>(
      'name_dari', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _namePashtoMeta =
      const VerificationMeta('namePashto');
  @override
  late final GeneratedColumn<String> namePashto = GeneratedColumn<String>(
      'name_pashto', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        nameDari,
        namePashto,
        nameEn,
        icon,
        color,
        createdAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('name_dari')) {
      context.handle(_nameDariMeta,
          nameDari.isAcceptableOrUnknown(data['name_dari']!, _nameDariMeta));
    } else if (isInserting) {
      context.missing(_nameDariMeta);
    }
    if (data.containsKey('name_pashto')) {
      context.handle(
          _namePashtoMeta,
          namePashto.isAcceptableOrUnknown(
              data['name_pashto']!, _namePashtoMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      nameDari: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_dari'])!,
      namePashto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_pashto']),
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String shopId;
  final String nameDari;
  final String? namePashto;
  final String? nameEn;
  final String? icon;
  final String? color;
  final DateTime createdAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const Category(
      {required this.id,
      required this.shopId,
      required this.nameDari,
      this.namePashto,
      this.nameEn,
      this.icon,
      this.color,
      required this.createdAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['name_dari'] = Variable<String>(nameDari);
    if (!nullToAbsent || namePashto != null) {
      map['name_pashto'] = Variable<String>(namePashto);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      shopId: Value(shopId),
      nameDari: Value(nameDari),
      namePashto: namePashto == null && nullToAbsent
          ? const Value.absent()
          : Value(namePashto),
      nameEn:
          nameEn == null && nullToAbsent ? const Value.absent() : Value(nameEn),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      nameDari: serializer.fromJson<String>(json['nameDari']),
      namePashto: serializer.fromJson<String?>(json['namePashto']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'nameDari': serializer.toJson<String>(nameDari),
      'namePashto': serializer.toJson<String?>(namePashto),
      'nameEn': serializer.toJson<String?>(nameEn),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Category copyWith(
          {String? id,
          String? shopId,
          String? nameDari,
          Value<String?> namePashto = const Value.absent(),
          Value<String?> nameEn = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          Value<String?> color = const Value.absent(),
          DateTime? createdAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      Category(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        nameDari: nameDari ?? this.nameDari,
        namePashto: namePashto.present ? namePashto.value : this.namePashto,
        nameEn: nameEn.present ? nameEn.value : this.nameEn,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        createdAt: createdAt ?? this.createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      nameDari: data.nameDari.present ? data.nameDari.value : this.nameDari,
      namePashto:
          data.namePashto.present ? data.namePashto.value : this.namePashto,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('nameDari: $nameDari, ')
          ..write('namePashto: $namePashto, ')
          ..write('nameEn: $nameEn, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shopId, nameDari, namePashto, nameEn,
      icon, color, createdAt, syncStatus, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.nameDari == this.nameDari &&
          other.namePashto == this.namePashto &&
          other.nameEn == this.nameEn &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> nameDari;
  final Value<String?> namePashto;
  final Value<String?> nameEn;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.nameDari = const Value.absent(),
    this.namePashto = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String nameDari,
    this.namePashto = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        nameDari = Value(nameDari);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? nameDari,
    Expression<String>? namePashto,
    Expression<String>? nameEn,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (nameDari != null) 'name_dari': nameDari,
      if (namePashto != null) 'name_pashto': namePashto,
      if (nameEn != null) 'name_en': nameEn,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? nameDari,
      Value<String?>? namePashto,
      Value<String?>? nameEn,
      Value<String?>? icon,
      Value<String?>? color,
      Value<DateTime>? createdAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      nameDari: nameDari ?? this.nameDari,
      namePashto: namePashto ?? this.namePashto,
      nameEn: nameEn ?? this.nameEn,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (nameDari.present) {
      map['name_dari'] = Variable<String>(nameDari.value);
    }
    if (namePashto.present) {
      map['name_pashto'] = Variable<String>(namePashto.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('nameDari: $nameDari, ')
          ..write('namePashto: $namePashto, ')
          ..write('nameEn: $nameEn, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'rate_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}');
  static const VerificationMeta _fromCurrencyMeta =
      const VerificationMeta('fromCurrency');
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
      'from_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toCurrencyMeta =
      const VerificationMeta('toCurrency');
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
      'to_currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, fromCurrency, toCurrency, rate, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_currency')) {
      context.handle(
          _fromCurrencyMeta,
          fromCurrency.isAcceptableOrUnknown(
              data['from_currency']!, _fromCurrencyMeta));
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
          _toCurrencyMeta,
          toCurrency.isAcceptableOrUnknown(
              data['to_currency']!, _toCurrencyMeta));
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_currency'])!,
      toCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_currency'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime fetchedAt;
  const ExchangeRate(
      {required this.id,
      required this.fromCurrency,
      required this.toCurrency,
      required this.rate,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<double>(rate);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<String>(json['id']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<double>(rate),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  ExchangeRate copyWith(
          {String? id,
          String? fromCurrency,
          String? toCurrency,
          double? rate,
          DateTime? fetchedAt}) =>
      ExchangeRate(
        id: id ?? this.id,
        fromCurrency: fromCurrency ?? this.fromCurrency,
        toCurrency: toCurrency ?? this.toCurrency,
        rate: rate ?? this.rate,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency:
          data.toCurrency.present ? data.toCurrency.value : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromCurrency, toCurrency, rate, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.fetchedAt == this.fetchedAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<String> id;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<double> rate;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fromCurrency = Value(fromCurrency),
        toCurrency = Value(toCurrency),
        rate = Value(rate);
  static Insertable<ExchangeRate> custom({
    Expression<String>? id,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<double>? rate,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromCurrency,
      Value<String>? toCurrency,
      Value<double>? rate,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_sync_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _conflictResolvedMeta =
      const VerificationMeta('conflictResolved');
  @override
  late final GeneratedColumn<bool> conflictResolved = GeneratedColumn<bool>(
      'conflict_resolved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("conflict_resolved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        deviceId,
        targetTable,
        recordId,
        operation,
        payload,
        syncedAt,
        conflictResolved,
        errorMessage,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['table_name']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('conflict_resolved')) {
      context.handle(
          _conflictResolvedMeta,
          conflictResolved.isAcceptableOrUnknown(
              data['conflict_resolved']!, _conflictResolvedMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_name'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      conflictResolved: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}conflict_resolved'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final String id;
  final String? shopId;
  final String? deviceId;
  final String targetTable;
  final String recordId;
  final String operation;
  final String payload;
  final DateTime? syncedAt;
  final bool conflictResolved;
  final String? errorMessage;
  final DateTime createdAt;
  const SyncQueueItem(
      {required this.id,
      this.shopId,
      this.deviceId,
      required this.targetTable,
      required this.recordId,
      required this.operation,
      required this.payload,
      this.syncedAt,
      required this.conflictResolved,
      this.errorMessage,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || shopId != null) {
      map['shop_id'] = Variable<String>(shopId);
    }
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['table_name'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['conflict_resolved'] = Variable<bool>(conflictResolved);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      shopId:
          shopId == null && nullToAbsent ? const Value.absent() : Value(shopId),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      operation: Value(operation),
      payload: Value(payload),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      conflictResolved: Value(conflictResolved),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String?>(json['shopId']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      conflictResolved: serializer.fromJson<bool>(json['conflictResolved']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String?>(shopId),
      'deviceId': serializer.toJson<String?>(deviceId),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'conflictResolved': serializer.toJson<bool>(conflictResolved),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueItem copyWith(
          {String? id,
          Value<String?> shopId = const Value.absent(),
          Value<String?> deviceId = const Value.absent(),
          String? targetTable,
          String? recordId,
          String? operation,
          String? payload,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? conflictResolved,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt}) =>
      SyncQueueItem(
        id: id ?? this.id,
        shopId: shopId.present ? shopId.value : this.shopId,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        targetTable: targetTable ?? this.targetTable,
        recordId: recordId ?? this.recordId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        conflictResolved: conflictResolved ?? this.conflictResolved,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueItem copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      conflictResolved: data.conflictResolved.present
          ? data.conflictResolved.value
          : this.conflictResolved,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('deviceId: $deviceId, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('conflictResolved: $conflictResolved, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shopId, deviceId, targetTable, recordId,
      operation, payload, syncedAt, conflictResolved, errorMessage, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.deviceId == this.deviceId &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.syncedAt == this.syncedAt &&
          other.conflictResolved == this.conflictResolved &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<String> id;
  final Value<String?> shopId;
  final Value<String?> deviceId;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime?> syncedAt;
  final Value<bool> conflictResolved;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.conflictResolved = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String targetTable,
    required String recordId,
    required String operation,
    required String payload,
    this.syncedAt = const Value.absent(),
    this.conflictResolved = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : targetTable = Value(targetTable),
        recordId = Value(recordId),
        operation = Value(operation),
        payload = Value(payload);
  static Insertable<SyncQueueItem> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? deviceId,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? syncedAt,
    Expression<bool>? conflictResolved,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (deviceId != null) 'device_id': deviceId,
      if (targetTable != null) 'table_name': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (conflictResolved != null) 'conflict_resolved': conflictResolved,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String?>? shopId,
      Value<String?>? deviceId,
      Value<String>? targetTable,
      Value<String>? recordId,
      Value<String>? operation,
      Value<String>? payload,
      Value<DateTime?>? syncedAt,
      Value<bool>? conflictResolved,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      deviceId: deviceId ?? this.deviceId,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      syncedAt: syncedAt ?? this.syncedAt,
      conflictResolved: conflictResolved ?? this.conflictResolved,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (conflictResolved.present) {
      map['conflict_resolved'] = Variable<bool>(conflictResolved.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('deviceId: $deviceId, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('conflictResolved: $conflictResolved, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          'local_dev_${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
      'shop_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appVersionMeta =
      const VerificationMeta('appVersion');
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
      'app_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shopId,
        deviceId,
        platform,
        appVersion,
        lastSyncAt,
        createdAt,
        syncStatus,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_id')) {
      context.handle(_shopIdMeta,
          shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta));
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
          _appVersionMeta,
          appVersion.isAcceptableOrUnknown(
              data['app_version']!, _appVersionMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shopId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform'])!,
      appVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_version']),
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final String id;
  final String shopId;
  final String deviceId;
  final String platform;
  final String? appVersion;
  final DateTime? lastSyncAt;
  final DateTime createdAt;
  final String syncStatus;
  final DateTime? syncedAt;
  const Device(
      {required this.id,
      required this.shopId,
      required this.deviceId,
      required this.platform,
      this.appVersion,
      this.lastSyncAt,
      required this.createdAt,
      required this.syncStatus,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shop_id'] = Variable<String>(shopId);
    map['device_id'] = Variable<String>(deviceId);
    map['platform'] = Variable<String>(platform);
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      shopId: Value(shopId),
      deviceId: Value(deviceId),
      platform: Value(platform),
      appVersion: appVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(appVersion),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<String>(json['id']),
      shopId: serializer.fromJson<String>(json['shopId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      platform: serializer.fromJson<String>(json['platform']),
      appVersion: serializer.fromJson<String?>(json['appVersion']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shopId': serializer.toJson<String>(shopId),
      'deviceId': serializer.toJson<String>(deviceId),
      'platform': serializer.toJson<String>(platform),
      'appVersion': serializer.toJson<String?>(appVersion),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Device copyWith(
          {String? id,
          String? shopId,
          String? deviceId,
          String? platform,
          Value<String?> appVersion = const Value.absent(),
          Value<DateTime?> lastSyncAt = const Value.absent(),
          DateTime? createdAt,
          String? syncStatus,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      Device(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        deviceId: deviceId ?? this.deviceId,
        platform: platform ?? this.platform,
        appVersion: appVersion.present ? appVersion.value : this.appVersion,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
        createdAt: createdAt ?? this.createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      platform: data.platform.present ? data.platform.value : this.platform,
      appVersion:
          data.appVersion.present ? data.appVersion.value : this.appVersion,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('deviceId: $deviceId, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shopId, deviceId, platform, appVersion,
      lastSyncAt, createdAt, syncStatus, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.shopId == this.shopId &&
          other.deviceId == this.deviceId &&
          other.platform == this.platform &&
          other.appVersion == this.appVersion &&
          other.lastSyncAt == this.lastSyncAt &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.syncedAt == this.syncedAt);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<String> id;
  final Value<String> shopId;
  final Value<String> deviceId;
  final Value<String> platform;
  final Value<String?> appVersion;
  final Value<DateTime?> lastSyncAt;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.shopId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.platform = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String shopId,
    required String deviceId,
    required String platform,
    this.appVersion = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shopId = Value(shopId),
        deviceId = Value(deviceId),
        platform = Value(platform);
  static Insertable<Device> custom({
    Expression<String>? id,
    Expression<String>? shopId,
    Expression<String>? deviceId,
    Expression<String>? platform,
    Expression<String>? appVersion,
    Expression<DateTime>? lastSyncAt,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopId != null) 'shop_id': shopId,
      if (deviceId != null) 'device_id': deviceId,
      if (platform != null) 'platform': platform,
      if (appVersion != null) 'app_version': appVersion,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? shopId,
      Value<String>? deviceId,
      Value<String>? platform,
      Value<String?>? appVersion,
      Value<DateTime?>? lastSyncAt,
      Value<DateTime>? createdAt,
      Value<String>? syncStatus,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return DevicesCompanion(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('shopId: $shopId, ')
          ..write('deviceId: $deviceId, ')
          ..write('platform: $platform, ')
          ..write('appVersion: $appVersion, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShopsTable shops = $ShopsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $DebtPaymentsTable debtPayments = $DebtPaymentsTable(this);
  late final $InventoryAdjustmentsTable inventoryAdjustments =
      $InventoryAdjustmentsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final ShopsDao shopsDao = ShopsDao(this as AppDatabase);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final CustomersDao customersDao = CustomersDao(this as AppDatabase);
  late final SalesDao salesDao = SalesDao(this as AppDatabase);
  late final DebtsDao debtsDao = DebtsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        shops,
        products,
        customers,
        sales,
        saleItems,
        debts,
        debtPayments,
        inventoryAdjustments,
        categories,
        exchangeRates,
        syncQueue,
        devices
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('shops',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('products', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ShopsTableCreateCompanionBuilder = ShopsCompanion Function({
  Value<String> id,
  required String ownerId,
  required String name,
  Value<String?> nameDari,
  Value<String?> phone,
  Value<String> city,
  Value<String?> district,
  Value<String> shopType,
  Value<String> currencyPref,
  Value<String> languagePref,
  Value<String> subscriptionStatus,
  Value<DateTime> trialEndsAt,
  Value<DateTime?> subscriptionEndsAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$ShopsTableUpdateCompanionBuilder = ShopsCompanion Function({
  Value<String> id,
  Value<String> ownerId,
  Value<String> name,
  Value<String?> nameDari,
  Value<String?> phone,
  Value<String> city,
  Value<String?> district,
  Value<String> shopType,
  Value<String> currencyPref,
  Value<String> languagePref,
  Value<String> subscriptionStatus,
  Value<DateTime> trialEndsAt,
  Value<DateTime?> subscriptionEndsAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

final class $$ShopsTableReferences
    extends BaseReferences<_$AppDatabase, $ShopsTable, Shop> {
  $$ShopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName: $_aliasNameGenerator(db.shops.id, db.products.shopId));

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.shopId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShopsTableFilterComposer extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get district => $composableBuilder(
      column: $table.district, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopType => $composableBuilder(
      column: $table.shopType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyPref => $composableBuilder(
      column: $table.currencyPref, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languagePref => $composableBuilder(
      column: $table.languagePref, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get subscriptionEndsAt => $composableBuilder(
      column: $table.subscriptionEndsAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.shopId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShopsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get district => $composableBuilder(
      column: $table.district, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopType => $composableBuilder(
      column: $table.shopType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyPref => $composableBuilder(
      column: $table.currencyPref,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languagePref => $composableBuilder(
      column: $table.languagePref,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get subscriptionEndsAt => $composableBuilder(
      column: $table.subscriptionEndsAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$ShopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopsTable> {
  $$ShopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameDari =>
      $composableBuilder(column: $table.nameDari, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get shopType =>
      $composableBuilder(column: $table.shopType, builder: (column) => column);

  GeneratedColumn<String> get currencyPref => $composableBuilder(
      column: $table.currencyPref, builder: (column) => column);

  GeneratedColumn<String> get languagePref => $composableBuilder(
      column: $table.languagePref, builder: (column) => column);

  GeneratedColumn<String> get subscriptionStatus => $composableBuilder(
      column: $table.subscriptionStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get trialEndsAt => $composableBuilder(
      column: $table.trialEndsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get subscriptionEndsAt => $composableBuilder(
      column: $table.subscriptionEndsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.shopId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShopsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShopsTable,
    Shop,
    $$ShopsTableFilterComposer,
    $$ShopsTableOrderingComposer,
    $$ShopsTableAnnotationComposer,
    $$ShopsTableCreateCompanionBuilder,
    $$ShopsTableUpdateCompanionBuilder,
    (Shop, $$ShopsTableReferences),
    Shop,
    PrefetchHooks Function({bool productsRefs})> {
  $$ShopsTableTableManager(_$AppDatabase db, $ShopsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameDari = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String?> district = const Value.absent(),
            Value<String> shopType = const Value.absent(),
            Value<String> currencyPref = const Value.absent(),
            Value<String> languagePref = const Value.absent(),
            Value<String> subscriptionStatus = const Value.absent(),
            Value<DateTime> trialEndsAt = const Value.absent(),
            Value<DateTime?> subscriptionEndsAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopsCompanion(
            id: id,
            ownerId: ownerId,
            name: name,
            nameDari: nameDari,
            phone: phone,
            city: city,
            district: district,
            shopType: shopType,
            currencyPref: currencyPref,
            languagePref: languagePref,
            subscriptionStatus: subscriptionStatus,
            trialEndsAt: trialEndsAt,
            subscriptionEndsAt: subscriptionEndsAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String ownerId,
            required String name,
            Value<String?> nameDari = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String?> district = const Value.absent(),
            Value<String> shopType = const Value.absent(),
            Value<String> currencyPref = const Value.absent(),
            Value<String> languagePref = const Value.absent(),
            Value<String> subscriptionStatus = const Value.absent(),
            Value<DateTime> trialEndsAt = const Value.absent(),
            Value<DateTime?> subscriptionEndsAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopsCompanion.insert(
            id: id,
            ownerId: ownerId,
            name: name,
            nameDari: nameDari,
            phone: phone,
            city: city,
            district: district,
            shopType: shopType,
            currencyPref: currencyPref,
            languagePref: languagePref,
            subscriptionStatus: subscriptionStatus,
            trialEndsAt: trialEndsAt,
            subscriptionEndsAt: subscriptionEndsAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ShopsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<Shop, $ShopsTable, Product>(
                        currentTable: table,
                        referencedTable:
                            $$ShopsTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShopsTableReferences(db, table, p0).productsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shopId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShopsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShopsTable,
    Shop,
    $$ShopsTableFilterComposer,
    $$ShopsTableOrderingComposer,
    $$ShopsTableAnnotationComposer,
    $$ShopsTableCreateCompanionBuilder,
    $$ShopsTableUpdateCompanionBuilder,
    (Shop, $$ShopsTableReferences),
    Shop,
    PrefetchHooks Function({bool productsRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  required String shopId,
  required String nameDari,
  Value<String?> namePashto,
  Value<String?> nameEn,
  Value<String?> barcode,
  Value<double> price,
  Value<double?> costPrice,
  Value<double> stockQuantity,
  Value<double> minStockAlert,
  Value<String> unit,
  Value<String?> categoryId,
  Value<String?> imageUrl,
  Value<DateTime?> expiryDate,
  Value<bool> prescriptionRequired,
  Value<String?> dosage,
  Value<String?> manufacturer,
  Value<String?> color,
  Value<String?> sizeVariant,
  Value<String?> imei,
  Value<String?> serialNumber,
  Value<double?> weightGrams,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<String?> localId,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> nameDari,
  Value<String?> namePashto,
  Value<String?> nameEn,
  Value<String?> barcode,
  Value<double> price,
  Value<double?> costPrice,
  Value<double> stockQuantity,
  Value<double> minStockAlert,
  Value<String> unit,
  Value<String?> categoryId,
  Value<String?> imageUrl,
  Value<DateTime?> expiryDate,
  Value<bool> prescriptionRequired,
  Value<String?> dosage,
  Value<String?> manufacturer,
  Value<String?> color,
  Value<String?> sizeVariant,
  Value<String?> imei,
  Value<String?> serialNumber,
  Value<double?> weightGrams,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<String?> localId,
  Value<int> rowid,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShopsTable _shopIdTable(_$AppDatabase db) => db.shops
      .createAlias($_aliasNameGenerator(db.products.shopId, db.shops.id));

  $$ShopsTableProcessedTableManager get shopId {
    final $_column = $_itemColumn<String>('shop_id')!;

    final manager = $$ShopsTableTableManager($_db, $_db.shops)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shopIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get prescriptionRequired => $composableBuilder(
      column: $table.prescriptionRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sizeVariant => $composableBuilder(
      column: $table.sizeVariant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imei => $composableBuilder(
      column: $table.imei, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  $$ShopsTableFilterComposer get shopId {
    final $$ShopsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shopId,
        referencedTable: $db.shops,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShopsTableFilterComposer(
              $db: $db,
              $table: $db.shops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get prescriptionRequired => $composableBuilder(
      column: $table.prescriptionRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sizeVariant => $composableBuilder(
      column: $table.sizeVariant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imei => $composableBuilder(
      column: $table.imei, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  $$ShopsTableOrderingComposer get shopId {
    final $$ShopsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shopId,
        referencedTable: $db.shops,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShopsTableOrderingComposer(
              $db: $db,
              $table: $db.shops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameDari =>
      $composableBuilder(column: $table.nameDari, builder: (column) => column);

  GeneratedColumn<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get stockQuantity => $composableBuilder(
      column: $table.stockQuantity, builder: (column) => column);

  GeneratedColumn<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<bool> get prescriptionRequired => $composableBuilder(
      column: $table.prescriptionRequired, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get sizeVariant => $composableBuilder(
      column: $table.sizeVariant, builder: (column) => column);

  GeneratedColumn<String> get imei =>
      $composableBuilder(column: $table.imei, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => column);

  GeneratedColumn<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  $$ShopsTableAnnotationComposer get shopId {
    final $$ShopsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shopId,
        referencedTable: $db.shops,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShopsTableAnnotationComposer(
              $db: $db,
              $table: $db.shops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool shopId})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> nameDari = const Value.absent(),
            Value<String?> namePashto = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<double> minStockAlert = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<bool> prescriptionRequired = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> sizeVariant = const Value.absent(),
            Value<String?> imei = const Value.absent(),
            Value<String?> serialNumber = const Value.absent(),
            Value<double?> weightGrams = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            shopId: shopId,
            nameDari: nameDari,
            namePashto: namePashto,
            nameEn: nameEn,
            barcode: barcode,
            price: price,
            costPrice: costPrice,
            stockQuantity: stockQuantity,
            minStockAlert: minStockAlert,
            unit: unit,
            categoryId: categoryId,
            imageUrl: imageUrl,
            expiryDate: expiryDate,
            prescriptionRequired: prescriptionRequired,
            dosage: dosage,
            manufacturer: manufacturer,
            color: color,
            sizeVariant: sizeVariant,
            imei: imei,
            serialNumber: serialNumber,
            weightGrams: weightGrams,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            localId: localId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String nameDari,
            Value<String?> namePashto = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> costPrice = const Value.absent(),
            Value<double> stockQuantity = const Value.absent(),
            Value<double> minStockAlert = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<bool> prescriptionRequired = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> sizeVariant = const Value.absent(),
            Value<String?> imei = const Value.absent(),
            Value<String?> serialNumber = const Value.absent(),
            Value<double?> weightGrams = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            shopId: shopId,
            nameDari: nameDari,
            namePashto: namePashto,
            nameEn: nameEn,
            barcode: barcode,
            price: price,
            costPrice: costPrice,
            stockQuantity: stockQuantity,
            minStockAlert: minStockAlert,
            unit: unit,
            categoryId: categoryId,
            imageUrl: imageUrl,
            expiryDate: expiryDate,
            prescriptionRequired: prescriptionRequired,
            dosage: dosage,
            manufacturer: manufacturer,
            color: color,
            sizeVariant: sizeVariant,
            imei: imei,
            serialNumber: serialNumber,
            weightGrams: weightGrams,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            localId: localId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({shopId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shopId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shopId,
                    referencedTable: $$ProductsTableReferences._shopIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._shopIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function({bool shopId})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  required String shopId,
  required String name,
  Value<String?> phone,
  Value<double> totalOwed,
  Value<String?> notes,
  Value<DateTime?> lastInteractionAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<String?> localId,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> name,
  Value<String?> phone,
  Value<double> totalOwed,
  Value<String?> notes,
  Value<DateTime?> lastInteractionAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<String?> localId,
  Value<int> rowid,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalOwed => $composableBuilder(
      column: $table.totalOwed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastInteractionAt => $composableBuilder(
      column: $table.lastInteractionAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalOwed => $composableBuilder(
      column: $table.totalOwed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastInteractionAt => $composableBuilder(
      column: $table.lastInteractionAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get totalOwed =>
      $composableBuilder(column: $table.totalOwed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get lastInteractionAt => $composableBuilder(
      column: $table.lastInteractionAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double> totalOwed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> lastInteractionAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            shopId: shopId,
            name: name,
            phone: phone,
            totalOwed: totalOwed,
            notes: notes,
            lastInteractionAt: lastInteractionAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            localId: localId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<double> totalOwed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> lastInteractionAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            shopId: shopId,
            name: name,
            phone: phone,
            totalOwed: totalOwed,
            notes: notes,
            lastInteractionAt: lastInteractionAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            localId: localId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  required String shopId,
  Value<String?> customerId,
  required double totalAmount,
  required double totalAfn,
  Value<double> discount,
  Value<String> paymentMethod,
  Value<String> currency,
  Value<double> exchangeRate,
  Value<bool> isCredit,
  Value<String?> note,
  Value<bool> createdOffline,
  Value<String?> localId,
  Value<DateTime?> syncedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String?> customerId,
  Value<double> totalAmount,
  Value<double> totalAfn,
  Value<double> discount,
  Value<String> paymentMethod,
  Value<String> currency,
  Value<double> exchangeRate,
  Value<bool> isCredit,
  Value<String?> note,
  Value<bool> createdOffline,
  Value<String?> localId,
  Value<DateTime?> syncedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAfn => $composableBuilder(
      column: $table.totalAfn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCredit => $composableBuilder(
      column: $table.isCredit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get createdOffline => $composableBuilder(
      column: $table.createdOffline,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAfn => $composableBuilder(
      column: $table.totalAfn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCredit => $composableBuilder(
      column: $table.isCredit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get createdOffline => $composableBuilder(
      column: $table.createdOffline,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAfn =>
      $composableBuilder(column: $table.totalAfn, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<bool> get isCredit =>
      $composableBuilder(column: $table.isCredit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get createdOffline => $composableBuilder(
      column: $table.createdOffline, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> totalAfn = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<bool> isCredit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> createdOffline = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            shopId: shopId,
            customerId: customerId,
            totalAmount: totalAmount,
            totalAfn: totalAfn,
            discount: discount,
            paymentMethod: paymentMethod,
            currency: currency,
            exchangeRate: exchangeRate,
            isCredit: isCredit,
            note: note,
            createdOffline: createdOffline,
            localId: localId,
            syncedAt: syncedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            Value<String?> customerId = const Value.absent(),
            required double totalAmount,
            required double totalAfn,
            Value<double> discount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double> exchangeRate = const Value.absent(),
            Value<bool> isCredit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> createdOffline = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            shopId: shopId,
            customerId: customerId,
            totalAmount: totalAmount,
            totalAfn: totalAfn,
            discount: discount,
            paymentMethod: paymentMethod,
            currency: currency,
            exchangeRate: exchangeRate,
            isCredit: isCredit,
            note: note,
            createdOffline: createdOffline,
            localId: localId,
            syncedAt: syncedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  required String saleId,
  Value<String?> productId,
  required String productNameSnapshot,
  required double quantity,
  required double unitPrice,
  required double subtotal,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<String> saleId,
  Value<String?> productId,
  Value<String> productNameSnapshot,
  Value<double> quantity,
  Value<double> unitPrice,
  Value<double> subtotal,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String> productNameSnapshot = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            productNameSnapshot: productNameSnapshot,
            quantity: quantity,
            unitPrice: unitPrice,
            subtotal: subtotal,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String saleId,
            Value<String?> productId = const Value.absent(),
            required String productNameSnapshot,
            required double quantity,
            required double unitPrice,
            required double subtotal,
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            productNameSnapshot: productNameSnapshot,
            quantity: quantity,
            unitPrice: unitPrice,
            subtotal: subtotal,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()>;
typedef $$DebtsTableCreateCompanionBuilder = DebtsCompanion Function({
  Value<String> id,
  required String shopId,
  required String customerId,
  Value<String?> saleId,
  required double amountOriginal,
  Value<double> amountPaid,
  Value<double> amountRemaining,
  Value<String> status,
  Value<DateTime?> dueDate,
  Value<DateTime?> lastReminderSentAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$DebtsTableUpdateCompanionBuilder = DebtsCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> customerId,
  Value<String?> saleId,
  Value<double> amountOriginal,
  Value<double> amountPaid,
  Value<double> amountRemaining,
  Value<String> status,
  Value<DateTime?> dueDate,
  Value<DateTime?> lastReminderSentAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountOriginal => $composableBuilder(
      column: $table.amountOriginal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountRemaining => $composableBuilder(
      column: $table.amountRemaining,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReminderSentAt => $composableBuilder(
      column: $table.lastReminderSentAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountOriginal => $composableBuilder(
      column: $table.amountOriginal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountRemaining => $composableBuilder(
      column: $table.amountRemaining,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReminderSentAt => $composableBuilder(
      column: $table.lastReminderSentAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<double> get amountOriginal => $composableBuilder(
      column: $table.amountOriginal, builder: (column) => column);

  GeneratedColumn<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => column);

  GeneratedColumn<double> get amountRemaining => $composableBuilder(
      column: $table.amountRemaining, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReminderSentAt => $composableBuilder(
      column: $table.lastReminderSentAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$DebtsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
    Debt,
    PrefetchHooks Function()> {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> customerId = const Value.absent(),
            Value<String?> saleId = const Value.absent(),
            Value<double> amountOriginal = const Value.absent(),
            Value<double> amountPaid = const Value.absent(),
            Value<double> amountRemaining = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> lastReminderSentAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtsCompanion(
            id: id,
            shopId: shopId,
            customerId: customerId,
            saleId: saleId,
            amountOriginal: amountOriginal,
            amountPaid: amountPaid,
            amountRemaining: amountRemaining,
            status: status,
            dueDate: dueDate,
            lastReminderSentAt: lastReminderSentAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String customerId,
            Value<String?> saleId = const Value.absent(),
            required double amountOriginal,
            Value<double> amountPaid = const Value.absent(),
            Value<double> amountRemaining = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime?> lastReminderSentAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtsCompanion.insert(
            id: id,
            shopId: shopId,
            customerId: customerId,
            saleId: saleId,
            amountOriginal: amountOriginal,
            amountPaid: amountPaid,
            amountRemaining: amountRemaining,
            status: status,
            dueDate: dueDate,
            lastReminderSentAt: lastReminderSentAt,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DebtsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtsTable,
    Debt,
    $$DebtsTableFilterComposer,
    $$DebtsTableOrderingComposer,
    $$DebtsTableAnnotationComposer,
    $$DebtsTableCreateCompanionBuilder,
    $$DebtsTableUpdateCompanionBuilder,
    (Debt, BaseReferences<_$AppDatabase, $DebtsTable, Debt>),
    Debt,
    PrefetchHooks Function()>;
typedef $$DebtPaymentsTableCreateCompanionBuilder = DebtPaymentsCompanion
    Function({
  Value<String> id,
  required String debtId,
  required String shopId,
  required double amount,
  Value<String> paymentMethod,
  Value<String> currency,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$DebtPaymentsTableUpdateCompanionBuilder = DebtPaymentsCompanion
    Function({
  Value<String> id,
  Value<String> debtId,
  Value<String> shopId,
  Value<double> amount,
  Value<String> paymentMethod,
  Value<String> currency,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$DebtPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get debtId => $composableBuilder(
      column: $table.debtId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$DebtPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get debtId => $composableBuilder(
      column: $table.debtId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$DebtPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get debtId =>
      $composableBuilder(column: $table.debtId, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$DebtPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtPaymentsTable,
    DebtPayment,
    $$DebtPaymentsTableFilterComposer,
    $$DebtPaymentsTableOrderingComposer,
    $$DebtPaymentsTableAnnotationComposer,
    $$DebtPaymentsTableCreateCompanionBuilder,
    $$DebtPaymentsTableUpdateCompanionBuilder,
    (
      DebtPayment,
      BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPayment>
    ),
    DebtPayment,
    PrefetchHooks Function()> {
  $$DebtPaymentsTableTableManager(_$AppDatabase db, $DebtPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> debtId = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtPaymentsCompanion(
            id: id,
            debtId: debtId,
            shopId: shopId,
            amount: amount,
            paymentMethod: paymentMethod,
            currency: currency,
            notes: notes,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String debtId,
            required String shopId,
            required double amount,
            Value<String> paymentMethod = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtPaymentsCompanion.insert(
            id: id,
            debtId: debtId,
            shopId: shopId,
            amount: amount,
            paymentMethod: paymentMethod,
            currency: currency,
            notes: notes,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DebtPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtPaymentsTable,
    DebtPayment,
    $$DebtPaymentsTableFilterComposer,
    $$DebtPaymentsTableOrderingComposer,
    $$DebtPaymentsTableAnnotationComposer,
    $$DebtPaymentsTableCreateCompanionBuilder,
    $$DebtPaymentsTableUpdateCompanionBuilder,
    (
      DebtPayment,
      BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPayment>
    ),
    DebtPayment,
    PrefetchHooks Function()>;
typedef $$InventoryAdjustmentsTableCreateCompanionBuilder
    = InventoryAdjustmentsCompanion Function({
  Value<String> id,
  required String shopId,
  required String productId,
  required double quantityBefore,
  required double quantityAfter,
  required double quantityChange,
  required String reason,
  Value<String?> notes,
  Value<DateTime> adjustedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$InventoryAdjustmentsTableUpdateCompanionBuilder
    = InventoryAdjustmentsCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> productId,
  Value<double> quantityBefore,
  Value<double> quantityAfter,
  Value<double> quantityChange,
  Value<String> reason,
  Value<String?> notes,
  Value<DateTime> adjustedAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$InventoryAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityBefore => $composableBuilder(
      column: $table.quantityBefore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityAfter => $composableBuilder(
      column: $table.quantityAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityChange => $composableBuilder(
      column: $table.quantityChange,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get adjustedAt => $composableBuilder(
      column: $table.adjustedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$InventoryAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityBefore => $composableBuilder(
      column: $table.quantityBefore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityAfter => $composableBuilder(
      column: $table.quantityAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityChange => $composableBuilder(
      column: $table.quantityChange,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get adjustedAt => $composableBuilder(
      column: $table.adjustedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$InventoryAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTable> {
  $$InventoryAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantityBefore => $composableBuilder(
      column: $table.quantityBefore, builder: (column) => column);

  GeneratedColumn<double> get quantityAfter => $composableBuilder(
      column: $table.quantityAfter, builder: (column) => column);

  GeneratedColumn<double> get quantityChange => $composableBuilder(
      column: $table.quantityChange, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get adjustedAt => $composableBuilder(
      column: $table.adjustedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$InventoryAdjustmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryAdjustmentsTable,
    InventoryAdjustment,
    $$InventoryAdjustmentsTableFilterComposer,
    $$InventoryAdjustmentsTableOrderingComposer,
    $$InventoryAdjustmentsTableAnnotationComposer,
    $$InventoryAdjustmentsTableCreateCompanionBuilder,
    $$InventoryAdjustmentsTableUpdateCompanionBuilder,
    (
      InventoryAdjustment,
      BaseReferences<_$AppDatabase, $InventoryAdjustmentsTable,
          InventoryAdjustment>
    ),
    InventoryAdjustment,
    PrefetchHooks Function()> {
  $$InventoryAdjustmentsTableTableManager(
      _$AppDatabase db, $InventoryAdjustmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryAdjustmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryAdjustmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<double> quantityBefore = const Value.absent(),
            Value<double> quantityAfter = const Value.absent(),
            Value<double> quantityChange = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> adjustedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryAdjustmentsCompanion(
            id: id,
            shopId: shopId,
            productId: productId,
            quantityBefore: quantityBefore,
            quantityAfter: quantityAfter,
            quantityChange: quantityChange,
            reason: reason,
            notes: notes,
            adjustedAt: adjustedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String productId,
            required double quantityBefore,
            required double quantityAfter,
            required double quantityChange,
            required String reason,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> adjustedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryAdjustmentsCompanion.insert(
            id: id,
            shopId: shopId,
            productId: productId,
            quantityBefore: quantityBefore,
            quantityAfter: quantityAfter,
            quantityChange: quantityChange,
            reason: reason,
            notes: notes,
            adjustedAt: adjustedAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InventoryAdjustmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $InventoryAdjustmentsTable,
        InventoryAdjustment,
        $$InventoryAdjustmentsTableFilterComposer,
        $$InventoryAdjustmentsTableOrderingComposer,
        $$InventoryAdjustmentsTableAnnotationComposer,
        $$InventoryAdjustmentsTableCreateCompanionBuilder,
        $$InventoryAdjustmentsTableUpdateCompanionBuilder,
        (
          InventoryAdjustment,
          BaseReferences<_$AppDatabase, $InventoryAdjustmentsTable,
              InventoryAdjustment>
        ),
        InventoryAdjustment,
        PrefetchHooks Function()>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  required String shopId,
  required String nameDari,
  Value<String?> namePashto,
  Value<String?> nameEn,
  Value<String?> icon,
  Value<String?> color,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> nameDari,
  Value<String?> namePashto,
  Value<String?> nameEn,
  Value<String?> icon,
  Value<String?> color,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameDari => $composableBuilder(
      column: $table.nameDari, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get nameDari =>
      $composableBuilder(column: $table.nameDari, builder: (column) => column);

  GeneratedColumn<String> get namePashto => $composableBuilder(
      column: $table.namePashto, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> nameDari = const Value.absent(),
            Value<String?> namePashto = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            shopId: shopId,
            nameDari: nameDari,
            namePashto: namePashto,
            nameEn: nameEn,
            icon: icon,
            color: color,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String nameDari,
            Value<String?> namePashto = const Value.absent(),
            Value<String?> nameEn = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            shopId: shopId,
            nameDari: nameDari,
            namePashto: namePashto,
            nameEn: nameEn,
            icon: icon,
            color: color,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  required String fromCurrency,
  required String toCurrency,
  required double rate,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> fromCurrency,
  Value<String> toCurrency,
  Value<double> rate,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
      column: $table.fromCurrency, builder: (column) => column);

  GeneratedColumn<String> get toCurrency => $composableBuilder(
      column: $table.toCurrency, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromCurrency = const Value.absent(),
            Value<String> toCurrency = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fromCurrency,
            required String toCurrency,
            required double rate,
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRate,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>
    ),
    ExchangeRate,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String?> shopId,
  Value<String?> deviceId,
  required String targetTable,
  required String recordId,
  required String operation,
  required String payload,
  Value<DateTime?> syncedAt,
  Value<bool> conflictResolved,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String?> shopId,
  Value<String?> deviceId,
  Value<String> targetTable,
  Value<String> recordId,
  Value<String> operation,
  Value<String> payload,
  Value<DateTime?> syncedAt,
  Value<bool> conflictResolved,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get conflictResolved => $composableBuilder(
      column: $table.conflictResolved,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get conflictResolved => $composableBuilder(
      column: $table.conflictResolved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get conflictResolved => $composableBuilder(
      column: $table.conflictResolved, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueItem,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueItem,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueItem>
    ),
    SyncQueueItem,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> shopId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> conflictResolved = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            shopId: shopId,
            deviceId: deviceId,
            targetTable: targetTable,
            recordId: recordId,
            operation: operation,
            payload: payload,
            syncedAt: syncedAt,
            conflictResolved: conflictResolved,
            errorMessage: errorMessage,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> shopId = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            required String targetTable,
            required String recordId,
            required String operation,
            required String payload,
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> conflictResolved = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            shopId: shopId,
            deviceId: deviceId,
            targetTable: targetTable,
            recordId: recordId,
            operation: operation,
            payload: payload,
            syncedAt: syncedAt,
            conflictResolved: conflictResolved,
            errorMessage: errorMessage,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueItem,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueItem,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueItem>
    ),
    SyncQueueItem,
    PrefetchHooks Function()>;
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  Value<String> id,
  required String shopId,
  required String deviceId,
  required String platform,
  Value<String?> appVersion,
  Value<DateTime?> lastSyncAt,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<String> id,
  Value<String> shopId,
  Value<String> deviceId,
  Value<String> platform,
  Value<String?> appVersion,
  Value<DateTime?> lastSyncAt,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopId => $composableBuilder(
      column: $table.shopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
      column: $table.appVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$DevicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
    Device,
    PrefetchHooks Function()> {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shopId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> platform = const Value.absent(),
            Value<String?> appVersion = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevicesCompanion(
            id: id,
            shopId: shopId,
            deviceId: deviceId,
            platform: platform,
            appVersion: appVersion,
            lastSyncAt: lastSyncAt,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String shopId,
            required String deviceId,
            required String platform,
            Value<String?> appVersion = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevicesCompanion.insert(
            id: id,
            shopId: shopId,
            deviceId: deviceId,
            platform: platform,
            appVersion: appVersion,
            lastSyncAt: lastSyncAt,
            createdAt: createdAt,
            syncStatus: syncStatus,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DevicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
    Device,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShopsTableTableManager get shops =>
      $$ShopsTableTableManager(_db, _db.shops);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$DebtPaymentsTableTableManager get debtPayments =>
      $$DebtPaymentsTableTableManager(_db, _db.debtPayments);
  $$InventoryAdjustmentsTableTableManager get inventoryAdjustments =>
      $$InventoryAdjustmentsTableTableManager(_db, _db.inventoryAdjustments);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
}
