// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AudioRecord {
  String get formattedDate => throw _privateConstructorUsedError;
  String get audioPath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AudioRecordCopyWith<AudioRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioRecordCopyWith<$Res> {
  factory $AudioRecordCopyWith(
          AudioRecord value, $Res Function(AudioRecord) then) =
      _$AudioRecordCopyWithImpl<$Res, AudioRecord>;
  @useResult
  $Res call({String formattedDate, String audioPath});
}

/// @nodoc
class _$AudioRecordCopyWithImpl<$Res, $Val extends AudioRecord>
    implements $AudioRecordCopyWith<$Res> {
  _$AudioRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formattedDate = null,
    Object? audioPath = null,
  }) {
    return _then(_value.copyWith(
      formattedDate: null == formattedDate
          ? _value.formattedDate
          : formattedDate // ignore: cast_nullable_to_non_nullable
              as String,
      audioPath: null == audioPath
          ? _value.audioPath
          : audioPath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AudioRecordCopyWith<$Res>
    implements $AudioRecordCopyWith<$Res> {
  factory _$$_AudioRecordCopyWith(
          _$_AudioRecord value, $Res Function(_$_AudioRecord) then) =
      __$$_AudioRecordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String formattedDate, String audioPath});
}

/// @nodoc
class __$$_AudioRecordCopyWithImpl<$Res>
    extends _$AudioRecordCopyWithImpl<$Res, _$_AudioRecord>
    implements _$$_AudioRecordCopyWith<$Res> {
  __$$_AudioRecordCopyWithImpl(
      _$_AudioRecord _value, $Res Function(_$_AudioRecord) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? formattedDate = null,
    Object? audioPath = null,
  }) {
    return _then(_$_AudioRecord(
      formattedDate: null == formattedDate
          ? _value.formattedDate
          : formattedDate // ignore: cast_nullable_to_non_nullable
              as String,
      audioPath: null == audioPath
          ? _value.audioPath
          : audioPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AudioRecord implements _AudioRecord {
  const _$_AudioRecord({required this.formattedDate, required this.audioPath});

  @override
  final String formattedDate;
  @override
  final String audioPath;

  @override
  String toString() {
    return 'AudioRecord(formattedDate: $formattedDate, audioPath: $audioPath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AudioRecord &&
            (identical(other.formattedDate, formattedDate) ||
                other.formattedDate == formattedDate) &&
            (identical(other.audioPath, audioPath) ||
                other.audioPath == audioPath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, formattedDate, audioPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AudioRecordCopyWith<_$_AudioRecord> get copyWith =>
      __$$_AudioRecordCopyWithImpl<_$_AudioRecord>(this, _$identity);
}

abstract class _AudioRecord implements AudioRecord {
  const factory _AudioRecord(
      {required final String formattedDate,
      required final String audioPath}) = _$_AudioRecord;

  @override
  String get formattedDate;
  @override
  String get audioPath;
  @override
  @JsonKey(ignore: true)
  _$$_AudioRecordCopyWith<_$_AudioRecord> get copyWith =>
      throw _privateConstructorUsedError;
}
