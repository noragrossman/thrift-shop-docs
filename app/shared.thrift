namespace java services.shared
namespace scala services.scala.shared
namespace rb ThriftShop.Shared

typedef string CloudinaryPublicId
typedef string CloudinaryUrl
typedef string DateTime
typedef string DeepLink
typedef string IpAddress
typedef string RequestId
typedef string YouTubeUrl
typedef string Uid
typedef string Url
typedef i64 Timestamp

enum ArgumentExceptionCode {
  PRESENCE = 0,
  INVALID = 1,
  RESOURCE_NOT_FOUND = 2,
}

enum Service {
  ACTION = 0,
  AUTH = 1,
  BRIGADE = 2,
  CAMPAIGN = 3,
  EVENT_BUS = 4,
  INFLUENCE = 5,
  CONTACT = 6,
  CAMPAIGN_RECOMMENDATION = 7,
  GROUP = 8,
  EXPERIMENT = 9,
  ALIGNMENT = 10,
  CIVIC_DATA = 11,
}

enum EntityRole {
  ADMIN = 0,
  GUEST = 1,
  LOGGED_OUT = 2,
  USER = 3,
}

enum BoundaryLimitPaginationDirection {
  # NOTE: This does *not* affect the ordering of the paginated data set. It
  # just changes the page that we're fetching, i.e., the page before the
  # boundary or the page after the boundary.
  AFTER = 0,
  BEFORE = 1,
}

enum SortOrder {
  DESC = 1,
  ASC = 2,
}

enum ClientPlatform {
  UNKNOWN = 1,
  ANDROID = 2,
  WEB = 3,
  IOS = 4,
}

struct Entity {
  3: optional Uid uuid,
  2: EntityRole role,

  // 1: optional Uid uuid, // Deprecated because we used the Uuid type
}

// Parameter type which represents a union of the various thrift types that a parameter might be
union Parameter {
  // Uids will likely always use the string type (#3), but it is available in any case
  1: Uid uid_t,
  2: DateTime date_time_t,
  3: string string_t,
  4: i32 i32_t,
  5: i64 i64_t,
  6: bool bool_t,
  7: double double_t,
  // Special type which represents the nil/null case
  8: bool null_t,
}

// Struct used for sending oneself a message via the event bus in order to perform some async work.
// This is modeled similar to how Sidekiq works in the rails world, allowing the specification
// of a job class name, which must implement the #perform method, and an arbitrary list of params.
struct JobExecutionParams {
  1: string job_class,
  2: map<string, Parameter> job_params,
}

struct BoundaryLimitPaginationParams {
  1: BoundaryLimitPaginationDirection direction,
  2: i32 limit,
  3: optional Uid boundary_uid,
}

struct BoundaryLimitPageInfo {
  1: bool has_before,
  2: bool has_after,
  3: optional i32 total_count,
}

struct UtmParams {
  1: string utm_source,
  2: optional string utm_campaign,
  3: optional string utm_content,
  4: optional string utm_medium,
}

struct RequestContext {
  // If the request originated from an invitation or a share link, the UID
  // of the invitation or share is recorded here for tracking purposes.
  1: optional Uid invitation_uid,
  2: optional Uid share_uid,
  3: optional Uid email_message_uid,
  4: optional DeepLink install_deep_link,
  5: optional Url launched_url,
  6: optional UtmParams utm_params,
  7: optional ClientPlatform client_platform,
  8: optional IpAddress client_ip_address,
}

struct RequestHeaders {
  1: optional Entity entity,
  2: RequestId request_id,
  3: RequestContext context,
}

exception ArgumentException {
  1: string message,
  // The path to the problematic argument (represented as a series of
  // dot-delimited field names)
  2: string path,
  3: ArgumentExceptionCode code,
}

exception UnauthorizedException {
  1: string message,
}
