-- Fireflies is removed from Ctrl (Krish, 2026-11-14): subscription cancelled and
-- account deleted. decision_cases.source no longer accepts 'fireflies'.
-- Production held 0 rows with source = 'fireflies' (17 rows, all 'advisor'),
-- so no rows move. The guard below aborts instead of failing half way if one
-- has appeared since.
do $$
begin
  if exists (select 1 from public.decision_cases where source = 'fireflies') then
    raise exception 'decision_cases still has source = fireflies rows; move them before applying';
  end if;
end $$;

alter table public.decision_cases drop constraint if exists decision_cases_source_check;
alter table public.decision_cases
  add constraint decision_cases_source_check
  check (source in ('advisor', 'capture', 'voice'));
