class AdjustCurrentUserIdToNewPostgrest < ActiveRecord::Migration[4.2]
  def up
    execute %Q{
CREATE OR REPLACE FUNCTION public.current_user_id()
 RETURNS integer
 LANGUAGE plpgsql
 STABLE
AS $function$
BEGIN
  RETURN nullif(current_setting('request.jwt.claim.user_id'), '')::integer;
EXCEPTION
WHEN others THEN
  RETURN NULL::integer;
END
    $function$
;
}
  end

  def down
    execute %Q{
CREATE OR REPLACE FUNCTION public.current_user_id()
 RETURNS integer
 LANGUAGE plpgsql
 STABLE
AS $function$
BEGIN
  RETURN nullif(current_setting('postgrest.claims.user_id'), '')::integer;
EXCEPTION
WHEN others THEN
  RETURN NULL::integer;
END
    $function$
;
}
  end
end
