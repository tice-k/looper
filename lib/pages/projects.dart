import 'dart:io';
import 'package:flutter/material.dart';
import 'package:looper/helpers/project_card.dart';
import 'package:path_provider/path_provider.dart';

class ProjectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ProjectCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
