namespace java services.action
namespace scala services.scala.action
namespace rb ThriftShop.Action

include "./shared.thrift"
include "./event_bus/event_bus.thrift"

enum PetitionLifecycleState {
  DRAFT = 0,
  ACTIVE = 1,
  CLOSED = 2,
}

enum GetPetitionsSortField {
  LAUNCHED_AT = 0,
}

enum GetPetitionsSortOrder {
  ASC = 0,
  DESC = 1,
}

enum GetEntitySignaturesSortField {
  SIGNATURE_DATE = 1,
  GRADES_PUBLISHED_DATE = 2,
}

enum PetitionTargetType {
  CANDIDACY = 0,
  TERM = 1,
}

enum PetitionTargetGrade {
  SUCCESS = 0,
  FAILURE = 1,
  NEUTRAL = 2,
}

enum FilterTermsByEntityActionsOption {
  SOME_ACTIONS_TAKEN = 1,
  NO_ACTIONS_TAKEN = 2,
  NO_ACTIONS_AVAILABLE = 3,
}

struct PetitionGradeLegend {
  1: string success_description,
  2: string failure_description,
  3: string neutral_description,
}

struct Petition {
  1: shared.Uid uid,
  2: string title,
  3: string summary,
  4: string description,
  5: string target_description,
  6: shared.CloudinaryPublicId image,
  7: i32 signature_goal,
  8: shared.DateTime deadline,
  9: optional shared.DateTime launched_at,
  10: optional shared.DateTime closed_at,
  11: optional PetitionGradeLegend grade_legend,
  12: bool grades_published,
}

struct CreatePetitionRequest {
  1: string title,
  2: string summary,
  3: string description,
  4: string target_description,
  5: shared.CloudinaryPublicId image,
  6: i32 signature_goal,
  7: shared.DateTime deadline,
  8: optional PetitionGradeLegend grade_legend,
}

struct EditPetitionRequest {
  1: shared.Uid uid,
  2: optional string title,
  3: optional string summary,
  4: optional string description,
  5: optional string target_description,
  6: optional shared.CloudinaryPublicId image,
  7: optional i32 signature_goal,
  8: optional shared.DateTime deadline,
  9: optional PetitionGradeLegend grade_legend,
}

struct GetPetitionsFilterParams {
  1: optional list<shared.Uid> petition_uids,
  4: optional list<PetitionLifecycleState> lifecycle_states,
  3: optional list<shared.Uid> term_uids,
  5: optional list<shared.Uid> signed_by_entity_uuids,
  6: optional shared.Uid unsigned_by_entity_uuid,

  // 2: optional bool launched, // Replaced with lifecycle_states
}

struct GetEntitySignaturesFilterParams {
  1: optional list<shared.Uid> petition_uids, // If specified, return signatures on the matching petitions only
  2: optional bool graded, // If true, only fetch signatures on graded petitions
  3: optional list<shared.Uid> term_uids, // If given, only return signatures targeting these terms. Does not guarantee these terms represent this entity.
}

struct GetEntitySignaturesSortParams {
  1: GetEntitySignaturesSortField sort_field,
  2: shared.SortOrder sort_order,
}

struct GetPetitionTargetsFilterParams {
  1: optional list<PetitionTargetType> target_types,
  2: optional list<shared.Uid> exclude_term_uids, // Term UIDs that should not appear in the response
  3: optional list<shared.Uid> term_uids,
  4: optional list<shared.Uid> petition_uids,
  5: optional list<shared.Uid> petition_target_uids,
}

struct GetPetitionsSortParams {
  1: GetPetitionsSortField sort_field,
  2: GetPetitionsSortOrder sort_order,
}

struct GetPetitionsRequest {
  3: shared.BoundaryLimitPaginationParams pagination_params,
  4: optional GetPetitionsFilterParams filter_params,
  # NOTE: non-admins can't access draft petitions. For non-admins, if lifecycle_states are
  # not specified, this is implicitly filtered to ACTIVE and CLOSED.
  5: optional GetPetitionsSortParams sort_params,

  // 1: optional list<shared.Uid> petition_uids, // Moved to GetPetitionsFilterParams
  // 2: optional bool launched, // Moved to GetPetitionsFilterParams
}

struct PaginatedPetitions {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<Petition> petitions,
}

struct PetitionSignature {
  1: shared.Uid uid,
  2: shared.Uid entity_uuid,
  3: shared.Uid petition_uid,
  4: shared.DateTime created_at,
}

struct CreatePetitionSignatureRequest {
  1: shared.Uid entity_uuid,
  2: list<shared.Uid> entity_district_uids,
  3: shared.Uid petition_uid,
}

struct GetEntitySignaturesRequest {
  1: shared.Uid entity_uuid,
  2: shared.BoundaryLimitPaginationParams pagination_params,
  3: optional GetEntitySignaturesFilterParams filter_params,
  4: optional GetEntitySignaturesSortParams sort_params,
}

struct GetPetitionSignaturesRequest {
  1: shared.Uid petition_uid,
  # If specified, filter to signatures tied to entities with the provided
  # uuids.
  2: optional list<shared.Uid> entity_uuids,
  3: shared.BoundaryLimitPaginationParams pagination_params,
}

struct IsPermittedToSignPetitionRequest {
  1: shared.Uid petition_uid,
  2: list<shared.Uid> entity_district_uids,
}

struct PaginatedPetitionSignatures {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<PetitionSignature> petition_signatures,
}

struct PetitionTermTarget {
  3: shared.Uid uid,
  1: shared.Uid petition_uid,
  2: shared.Uid term_uid,
  4: optional PetitionTargetGrade grade,
}

struct PetitionCandidacyTarget {
  3: shared.Uid uid,
  1: shared.Uid petition_uid,
  2: shared.Uid candidacy_uid,
  4: optional PetitionTargetGrade grade,
}

union PetitionTarget {
  1: PetitionTermTarget term_target,
  2: PetitionCandidacyTarget candidacy_target,
}

struct PaginatedPetitionTargets {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<PetitionTarget> petition_targets,
}

struct AddTermTargetItem {
  1: shared.Uid term_uid,
  2: shared.Uid district_uid,
}

struct AddCandidacyTargetItem {
  1: shared.Uid candidacy_uid,
  2: shared.Uid district_uid,
}

struct AddPetitionTermTargetsRequest {
  1: shared.Uid petition_uid,
  2: list<AddTermTargetItem> term_targets,
}

struct AddPetitionCandidacyTargetsRequest {
  1: shared.Uid petition_uid,
  2: list<AddCandidacyTargetItem> candidacy_targets,
}

struct GradePetitionTargetsItem {
  1: shared.Uid petition_target_uid,
  2: PetitionTargetType petition_target_type,
  3: PetitionTargetGrade petition_target_grade,
}

struct GradePetitionTargetsRequest {
  1: list<GradePetitionTargetsItem> graded_items,
}

struct RemovePetitionTermTargetRequest {
  3: shared.Uid uid,

  // 1: shared.Uid petition_uid, // Deprecated in favor of uid
  // 2: shared.Uid term_uid, // Deprecated in favor of uid
}

struct RemovePetitionCandidacyTargetRequest {
  3: shared.Uid uid,

  // 1: shared.Uid petition_uid, // Deprecated in favor of uid
  // 2: shared.Uid candidacy_uid, // Deprecated in favor of uid
}

struct GetPetitionTargetsRequest {
  2: shared.BoundaryLimitPaginationParams pagination_params,
  4: optional GetPetitionTargetsFilterParams filter_params,

  // 1: optional shared.Uid petition_uid, // Deprecated in favor of GetPetitionTargetsFilterParams.petition_uids
  // 3: optional PetitionTargetType target_type, // Deprecated in favor of GetPetitionTargetsFilterParams.target_types
}

struct GetMatchingPetitionTermTargetsRequest {
  1: shared.Uid petition_uid,
  2: list<shared.Uid> term_uids,
}

struct PublishPetitionGradesRequest {
  1: shared.Uid petition_uid,
}

struct LaunchPetitionRequest {
  1: shared.Uid petition_uid,
}

struct ClosePetitionRequest {
  1: shared.Uid petition_uid,
}

struct GetEntityTermPetitionGradeCountsRequest {
  1: shared.Uid entity_uuid,
  2: list<shared.Uid> term_uids,
}

struct EntityTermPetitionGradeCount {
  1: shared.Uid entity_uuid,
  2: shared.Uid term_uid,
  3: i32 success_count,
  4: i32 failure_count,
  5: i32 neutral_count,
}

struct FilterTermsByEntityActionsRequest {
  1: shared.Uid entity_uuid,          // The user whose actions are being considered
  2: list<shared.Uid> term_uids,      // The terms to reference actions against
  3: FilterTermsByEntityActionsOption filter_option,
  4: optional list<shared.Uid> petition_uids,  // A whitelist of petitions to consider when looking for actions not taken
}

struct GetPetitionTargetSignaturesCountRequest {
  1: shared.Uid petition_target_uid,
}

service ActionService {
  Petition create_petition(
    1: shared.RequestHeaders headers,
    2: CreatePetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  Petition edit_petition(
    1: shared.RequestHeaders headers,
    2: EditPetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  PaginatedPetitions get_petitions(
    1: shared.RequestHeaders headers,
    2: GetPetitionsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  PetitionSignature create_petition_signature(
    1: shared.RequestHeaders headers,
    2: CreatePetitionSignatureRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),


  PaginatedPetitionSignatures get_entity_signatures(
    1: shared.RequestHeaders headers,
    2: GetEntitySignaturesRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception, // Users may not be authorized to view the signatures of others
  ),

  PaginatedPetitionSignatures get_petition_signatures(
    1: shared.RequestHeaders headers,
    2: GetPetitionSignaturesRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  bool is_permitted_to_sign_petition(
    1: shared.RequestHeaders headers,
    2: IsPermittedToSignPetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  list<PetitionTermTarget> add_petition_term_targets(
    1: shared.RequestHeaders headers,
    2: AddPetitionTermTargetsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  )

  list<PetitionCandidacyTarget> add_petition_candidacy_targets(
    1: shared.RequestHeaders headers,
    2: AddPetitionCandidacyTargetsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  )

  void remove_petition_term_target(
    1: shared.RequestHeaders headers,
    2: RemovePetitionTermTargetRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  )

  void remove_petition_candidacy_target(
    1: shared.RequestHeaders headers,
    2: RemovePetitionCandidacyTargetRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  )

  list<PetitionTarget> grade_petition_targets(
    1: shared.RequestHeaders headers,
    2: GradePetitionTargetsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  )

  PaginatedPetitionTargets get_petition_targets(
    1: shared.RequestHeaders header,
    2: GetPetitionTargetsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  )

  list<PetitionTermTarget> get_matching_petition_term_targets(
    1: shared.RequestHeaders header,
    2: GetMatchingPetitionTermTargetsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  )

  Petition launch_petition(
    1: shared.RequestHeaders headers,
    2: LaunchPetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  Petition publish_petition_grades(
    1: shared.RequestHeaders headers,
    2: PublishPetitionGradesRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  Petition close_petition(
    1: shared.RequestHeaders headers,
    2: ClosePetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  list<EntityTermPetitionGradeCount> get_entity_term_petition_grade_counts(
    1: shared.RequestHeaders headers,
    2: GetEntityTermPetitionGradeCountsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  void receive_event_bus_message_parcel(
    1: shared.RequestHeaders headers,
    2: event_bus.MessageParcel message_parcel
  ),

  list<shared.Uid> filter_terms_by_entity_actions(
    1: shared.RequestHeaders headers,
    2: FilterTermsByEntityActionsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  )

  i32 get_petition_target_signatures_count(
    1: shared.RequestHeaders headers,
    2: GetPetitionTargetSignaturesCountRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  )
}
