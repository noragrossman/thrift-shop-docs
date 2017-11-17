namespace java services.campaign
namespace scala services.scala.campaign
namespace rb ThriftShop.Campaign

include "./shared.thrift"
include "./event_bus/event_bus.thrift"

struct Campaign {
  1: shared.Uid uid,
  # 2: bool launched = false, // Deprecated in favor of launched_at
  3: string name,
  4: shared.Uid leader_entity_uuid,
  5: string mission,
  6: shared.CloudinaryPublicId image,
  7: optional shared.DateTime launched_at,
  8: list<shared.Uid> topic_uids,
}

struct GetCampaignsRequest {
  1: optional list<shared.Uid> campaign_uids,
  2: optional bool launched,
  3: shared.BoundaryLimitPaginationParams pagination_params,
}

struct PaginatedCampaigns {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<Campaign> campaigns,
}

struct CreateCampaignRequest {
  # 1: bool launched = false,
  2: string name,
  3: shared.Uid leader_entity_uuid,
  4: string mission,
  5: shared.CloudinaryPublicId image,
  6: list<shared.Uid> topic_uids,
}

struct EditCampaignRequest {
  1: shared.Uid uid,
  2: optional string name,
  3: optional shared.Uid leader_entity_uuid,
  4: optional string mission,
  5: optional shared.CloudinaryPublicId image,
  6: optional list<shared.Uid> topic_uids,
}

struct AddPetitionRequest {
  1: shared.Uid campaign_uid,
  2: shared.Uid petition_uid,
}

struct GetPetitionUidsRequest {
  // TODO: (cleanup) make breaking change to remove the singular campaign_uid argument
  1: optional shared.Uid campaign_uid,
  2: optional list<shared.Uid> campaign_uids,
}

struct GetSupporterUidsRequest {
  1: shared.Uid campaign_uid,
  2: shared.BoundaryLimitPaginationParams pagination_params,
}

struct PaginatedSupporterUids {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<shared.Uid> supporter_uids,
}

struct LaunchCampaignRequest {
  1: shared.Uid campaign_uid,
}

struct GetCampaignForPetitionRequest {
  1: shared.Uid petition_uid,
}

struct CampaignUpdate {
  1: shared.Uid uid,
  2: shared.Uid campaign_uid,
  3: string title,
  4: optional shared.CloudinaryPublicId image,
  5: optional shared.YouTubeUrl video,
  6: string body,
  8: optional string rich_text_body, // Rich text version of body
  7: shared.DateTime created_at,
  9: optional string email_cta_text, // TODO: make required (EL-1631)
  10: optional string email_cta_url, // TODO: make required (EL-1631)
}

struct CreateCampaignUpdateRequest {
  1: shared.Uid campaign_uid,
  2: string title,
  3: optional shared.CloudinaryPublicId image,
  4: optional shared.YouTubeUrl video,
  5: string body,
  6: optional string rich_text_body,
  7: optional string email_cta_text, // TODO: make required (EL-1631)
  8: optional string email_cta_url, // TODO: make required (EL-1631)
}

struct EditCampaignUpdateRequest {
  1: shared.Uid uid,
  2: optional string title,
  3: optional shared.CloudinaryPublicId image,
  4: optional shared.YouTubeUrl video,
  5: optional string body,
  6: optional string rich_text_body,
  7: optional string email_cta_text, // TODO: make required (EL-1631)
  8: optional string email_cta_url, // TODO: make required (EL-1631)
}

struct PaginatedCampaignUpdates {
  1: shared.BoundaryLimitPageInfo page_info,
  2: list<CampaignUpdate> campaign_updates,
}

struct GetCampaignUpdatesRequest {
  1: optional shared.Uid campaign_uid,
  2: optional list<shared.Uid> campaign_update_uids,
  3: shared.BoundaryLimitPaginationParams pagination_params,
}

struct DeleteCampaignUpdateRequest {
  1: shared.Uid campaign_update_uid,
}

service CampaignService {
  Campaign create_campaign(
    1: shared.RequestHeaders headers,
    2: CreateCampaignRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  Campaign edit_campaign(
    1: shared.RequestHeaders headers,
    2: EditCampaignRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  PaginatedCampaigns get_campaigns(
    1: shared.RequestHeaders headers,
    2: GetCampaignsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  void add_petition(
    1: shared.RequestHeaders headers,
    2: AddPetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  list<shared.Uid> get_petition_uids(
    1: shared.RequestHeaders headers,
    2: GetPetitionUidsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  PaginatedSupporterUids get_supporter_uids(
    1: shared.RequestHeaders headers,
    2: GetSupporterUidsRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  Campaign launch_campaign(
    1: shared.RequestHeaders headers,
    2: LaunchCampaignRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  void receive_event_bus_message_parcel(
    1: shared.RequestHeaders headers,
    2: event_bus.MessageParcel message_parcel,
  ),

  Campaign get_campaign_for_petition(
    1: shared.RequestHeaders headers,
    2: GetCampaignForPetitionRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

  CampaignUpdate create_campaign_update(
    1: shared.RequestHeaders headers,
    2: CreateCampaignUpdateRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  CampaignUpdate edit_campaign_update(
    1: shared.RequestHeaders headers,
    2: EditCampaignUpdateRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  void delete_campaign_update (
    1: shared.RequestHeaders headers,
    2: DeleteCampaignUpdateRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
    2: shared.UnauthorizedException unauthorized_exception,
  ),

  PaginatedCampaignUpdates get_campaign_updates(
    1: shared.RequestHeaders headers,
    2: GetCampaignUpdatesRequest request,
  ) throws (
    1: shared.ArgumentException argument_exception,
  ),

}
