struct Address {
  // Unique identifier for address
  1: i32 id,
  2: string street_address,
  3: string city,
  4: string state,
  5: string country,
  6: optional string name,
}

// This service fetches addresses for people
service AddressService {
  Address get_address(
    1: i32 id,
  ),
}
