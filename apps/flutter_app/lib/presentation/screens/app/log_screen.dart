import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../providers/adherence_provider.dart';
import '../../providers/profile_provider.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentProfile = ref.watch(currentProfileProvider);
    final eventsAsync = ref.watch(adherenceEventsProvider);
    final summaryAsync = ref.watch(weeklyAdherenceProvider);
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adherenceLog,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Summary card
                    if (currentProfile != null)
                      summaryAsync.when(
                        data: (summary) => _SummaryCard(summary: summary, l10n: l10n, theme: theme),
                        loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                        error: (_, __) => const SizedBox(),
                      ),
                  ],
                ),
              ),
            ),
            
            // Events list
            if (currentProfile == null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined, size: 64, color: theme.colorScheme.outline),
                      const SizedBox(height: 16),
                      Text(l10n.noProfileSelected, style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
              )
            else
              eventsAsync.when(
                data: (events) => events.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 64, color: theme.colorScheme.outline),
                              const SizedBox(height: 16),
                              Text(l10n.noEventsFound, style: theme.textTheme.titleLarge),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _EventCard(
                              event: events[index],
                              l10n: l10n,
                              theme: theme,
                            ),
                            childCount: events.length,
                          ),
                        ),
                      ),
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => SliverFillRemaining(
                  child: Center(child: Text(l10n.errorLoadingData)),
                ),
              ),
              
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic summary;
  final AppLocalizations l10n;
  final ThemeData theme;
  
  const _SummaryCard({required this.summary, required this.l10n, required this.theme});
  
  @override
  Widget build(BuildContext context) {
    final percentage = summary.totalDoses > 0 
        ? (summary.takenCount / summary.totalDoses * 100).round() 
        : 100;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localeName == 'ar' ? 'نسبة الالتزام' : 'Adherence Rate',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  percentage >= 80 ? Icons.thumb_up : Icons.trending_up,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: l10n.localeName == 'ar' ? 'تم التناول' : 'Taken',
                value: '${summary.takenCount}',
                theme: theme,
              ),
              _StatItem(
                label: l10n.localeName == 'ar' ? 'تم التخطي' : 'Skipped',
                value: '${summary.skippedCount}',
                theme: theme,
              ),
              _StatItem(
                label: l10n.localeName == 'ar' ? 'فائت' : 'Missed',
                value: '${summary.missedCount}',
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  
  const _StatItem({required this.label, required this.value, required this.theme});
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final dynamic event;
  final AppLocalizations l10n;
  final ThemeData theme;
  
  const _EventCard({required this.event, required this.l10n, required this.theme});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventType.getLabel(l10n.localeName),
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat('MMM d, h:mm a', l10n.localeName).format(event.timestampUtc.toLocal()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
