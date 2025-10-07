import 'package:flutter/material.dart';
import '../../../core/database/tables.dart';
import 'school_metadata_view.dart';
import 'projects_metadata_view.dart';
import 'finance_metadata_view.dart';
import 'fitness_metadata_view.dart';

/// Router widget that renders domain-specific metadata based on domain type
class DomainMetadataWidget extends StatelessWidget {
  final Domain domain;
  final String? metadataJson;
  final bool compact; // If true, shows condensed version for cards

  const DomainMetadataWidget({
    super.key,
    required this.domain,
    this.metadataJson,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (metadataJson == null || metadataJson!.isEmpty) {
      return const SizedBox.shrink();
    }

    try {
      switch (domain) {
        case Domain.school:
          return SchoolMetadataView(
            metadataJson: metadataJson!,
            compact: compact,
          );

        case Domain.projects:
          return ProjectsMetadataView(
            metadataJson: metadataJson!,
            compact: compact,
          );

        case Domain.finance:
          return FinanceMetadataView(
            metadataJson: metadataJson!,
            compact: compact,
          );

        case Domain.health:
          return FitnessMetadataView(
            metadataJson: metadataJson!,
            compact: compact,
          );

        case Domain.dsa:
        case Domain.personal:
          // Generic fallback for domains without custom views yet
          return const SizedBox.shrink();
      }
    } catch (e) {
      // Graceful fallback if JSON parsing fails
      return const SizedBox.shrink();
    }
  }
}

