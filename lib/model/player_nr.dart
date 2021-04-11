import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Playernr extends Equatable{
  final String name;
  final String role;
  
  Playernr({
    @required this.name,
    @required this.role,
  });

  @override
  List<Object> get props => [name,role];
}
