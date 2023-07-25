use option::OptionTrait;
use traits::{Into, TryInto};
use bytes_31::{split_bytes31, U128IntoBytes31, U8IntoBytes31};

const POW_2_248: felt252 = 0x100000000000000000000000000000000000000000000000000000000000000;

#[test]
fn test_bytes31_to_from_felt252() {
    let zero_as_bytes31: Option<bytes31> = 0.try_into();
    assert(zero_as_bytes31.is_some(), '0 is not a bytes31');
    let zero_as_felt252 = zero_as_bytes31.unwrap().into();
    assert(zero_as_felt252 == 0_felt252, 'bad cast: 0');

    let one_as_bytes31: Option<bytes31> = 1.try_into();
    assert(one_as_bytes31.is_some(), '1 is not a bytes31');
    let one_as_felt252 = one_as_bytes31.unwrap().into();
    assert(one_as_felt252 == 1_felt252, 'bad cast: 1');

    let max_as_bytes31: Option<bytes31> = (POW_2_248 - 1).try_into();
    assert(max_as_bytes31.is_some(), '2^248 - 1 is not a bytes31');
    let max_as_felt252 = max_as_bytes31.unwrap().into();
    assert(max_as_felt252 == POW_2_248 - 1, 'bad cast: 2^248 - 1');

    let out_of_range: Option<bytes31> = POW_2_248.try_into();
    assert(out_of_range.is_none(), '2^248 is a bytes31');

    let out_of_range: Option<bytes31> = (-1).try_into();
    assert(out_of_range.is_none(), '-1 is a bytes31');
}

#[test]
fn test_u8_into_bytes31() {
    let one_u8 = 1_u8;
    let one_as_bytes31: bytes31 = one_u8.into();
    assert(one_as_bytes31.into() == 1_felt252, 'bad cast: 1');

    let max_u8 = 0xff_u8;
    let max_as_bytes31: bytes31 = max_u8.into();
    assert(max_as_bytes31.into() == 0xff_felt252, 'bad cast: 2^8 - 1');
}

#[test]
fn test_u16_into_bytes31() {
    let one_u16 = 1_u16;
    let one_as_bytes31: bytes31 = one_u16.into();
    assert(one_as_bytes31.into() == 1_felt252, 'bad cast: 1');

    let max_u16 = 0xffff_u16;
    let max_as_bytes31: bytes31 = max_u16.into();
    assert(max_as_bytes31.into() == 0xffff_felt252, 'bad cast: 2^16 - 1');
}

#[test]
fn test_u32_into_bytes31() {
    let one_u32 = 1_u32;
    let one_as_bytes31: bytes31 = one_u32.into();
    assert(one_as_bytes31.into() == 1_felt252, 'bad cast: 1');

    let max_u32 = 0xffffffff_u32;
    let max_as_bytes31: bytes31 = max_u32.into();
    assert(max_as_bytes31.into() == 0xffffffff_felt252, 'bad cast: 2^32 - 1');
}

#[test]
fn test_u64_into_bytes31() {
    let one_u64 = 1_u64;
    let one_as_bytes31: bytes31 = one_u64.into();
    assert(one_as_bytes31.into() == 1_felt252, 'bad cast: 1');

    let max_u64 = 0xffffffffffffffff_u64;
    let max_as_bytes31: bytes31 = max_u64.into();
    assert(max_as_bytes31.into() == 0xffffffffffffffff_felt252, 'bad cast: 2^64 - 1');
}

#[test]
fn test_u128_into_bytes31() {
    let one_u128 = 1_u128;
    let one_as_bytes31: bytes31 = one_u128.into();
    assert(one_as_bytes31.into() == 1_felt252, 'bad cast: 1');

    let max_u128 = 0xffffffffffffffffffffffffffffffff_u128;
    let max_as_bytes31: bytes31 = max_u128.into();
    assert(
        max_as_bytes31.into() == 0xffffffffffffffffffffffffffffffff_felt252, 'bad cast: 2^128 - 1'
    );
}

#[test]
fn test_split_bytes31() {
    let (left, right) = split_bytes31(0x1122, 2, 1);
    assert(left == 0x22, 'bad split (2, 1) left');
    assert(right == 0x11, 'bad split (2, 1) right');

    let x = 0x112233445566778899aabbccddeeff00112233;
    let (left, right) = split_bytes31(x, 19, 0);
    assert(left == 0, 'bad split (19, 0) left');
    assert(right == 0x112233445566778899aabbccddeeff00112233, 'bad split (19, 0) right');

    let (left, right) = split_bytes31(x, 19, 1);
    assert(left == 0x33, 'bad split (19, 1) left');
    assert(right == 0x112233445566778899aabbccddeeff001122, 'bad split (19, 1) right');

    let (left, right) = split_bytes31(x, 19, 15);
    assert(left == 0x5566778899aabbccddeeff00112233, 'bad split (19, 15) left');
    assert(right == 0x11223344, 'bad split (19, 15) right');

    let (left, right) = split_bytes31(x, 19, 16);
    assert(left == 0x445566778899aabbccddeeff00112233, 'bad split (19, 16) left');
    assert(right == 0x112233, 'bad split (19, 16) right');

    let (left, right) = split_bytes31(x, 19, 18);
    assert(left == 0x2233445566778899aabbccddeeff00112233, 'bad split (19, 18) left');
    assert(right == 0x11, 'bad split (19, 18) right');

    let (left, right) = split_bytes31(x, 19, 19);
    assert(left == 0x112233445566778899aabbccddeeff00112233, 'bad split (19, 19) left');
    assert(right == 0, 'bad split (19, 19) right');
}