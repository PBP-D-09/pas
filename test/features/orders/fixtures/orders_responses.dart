// Respons asli /api/v1/orders/ dari web Django (data seed_demo).
// ignore_for_file: lines_longer_than_80_chars

const ordersResponse = r'''
{
  "status_counts": {
    "pending": 3,
    "processing": 2,
    "on_the_way": 2,
    "delivered": 4,
    "cancelled": 1,
    "all": 12
  },
  "active_status": "all",
  "date_range": "all",
  "unreturned_containers": 1,
  "container_return_points": 10,
  "count": 5,
  "results": [
    {
      "id": "dec7d2ab-f0bf-4c9e-95a0-cab2dd172f1b",
      "order_code": "#DEMO-0001",
      "status": "pending",
      "status_display": "Pending",
      "packaging_type": "reusable",
      "packaging_display": "Reusable container",
      "reusable_returned": false,
      "reusable_containers": 2,
      "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
      "delivery_notes": "Data pesanan contoh untuk demonstrasi SustainaBowl.",
      "delivery_eta_minutes": 25,
      "subtotal": 115000,
      "packaging_fee": 5000,
      "delivery_fee": 7000,
      "total_price": 127000,
      "eco_points": 20,
      "total_items_count": 3,
      "can_cancel": true,
      "can_edit_note": true,
      "created_at": "2026-11-20T13:15:20.887166Z",
      "updated_at": "2026-11-20T14:15:20.891650Z",
      "items": [
        {
          "id": "3e67d76a-262f-4ae4-949e-558abc43708a",
          "menu_item_id": "31fb46bf-2ab8-4702-9665-4e816467407e",
          "item_name": "Grilled Tempeh Bowl",
          "tenant_name": "Greenhouse Kitchen",
          "price": 45000,
          "quantity": 2,
          "subtotal": 90000
        },
        {
          "id": "2ee01a0d-f785-4f32-9aa7-2296c7834eeb",
          "menu_item_id": "46692a1d-f4a1-40ee-84ad-ca8354869abd",
          "item_name": "Berry Chia Pudding",
          "tenant_name": "Berry Baik",
          "price": 25000,
          "quantity": 1,
          "subtotal": 25000
        }
      ]
    },
    {
      "id": "f9b4476c-aad2-4b91-9df9-6d2149b8761e",
      "order_code": "#DEMO-0004",
      "status": "processing",
      "status_display": "Processing",
      "packaging_type": "compostable",
      "packaging_display": "Compostable box",
      "reusable_returned": false,
      "reusable_containers": 0,
      "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
      "delivery_notes": "Data pesanan contoh untuk demonstrasi SustainaBowl.",
      "delivery_eta_minutes": 25,
      "subtotal": 44000,
      "packaging_fee": 2000,
      "delivery_fee": 7000,
      "total_price": 53000,
      "eco_points": 10,
      "total_items_count": 2,
      "can_cancel": false,
      "can_edit_note": false,
      "created_at": "2026-11-19T14:15:20.887166Z",
      "updated_at": "2026-11-20T14:15:20.920450Z",
      "items": [
        {
          "id": "3783f006-72c5-4d16-b275-e6206a88a70b",
          "menu_item_id": "fb64ccd9-3b5f-41ad-9b1b-19479f441234",
          "item_name": "Ginger Kombucha",
          "tenant_name": "Berry Baik",
          "price": 22000,
          "quantity": 2,
          "subtotal": 44000
        }
      ]
    },
    {
      "id": "ae6ff00d-64bb-4f47-a0fd-f4fa770c54ed",
      "order_code": "#DEMO-0006",
      "status": "on_the_way",
      "status_display": "On the way",
      "packaging_type": "compostable",
      "packaging_display": "Compostable box",
      "reusable_returned": false,
      "reusable_containers": 0,
      "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
      "delivery_notes": "Data pesanan contoh untuk demonstrasi SustainaBowl.",
      "delivery_eta_minutes": 30,
      "subtotal": 43000,
      "packaging_fee": 2000,
      "delivery_fee": 9000,
      "total_price": 54000,
      "eco_points": 10,
      "total_items_count": 1,
      "can_cancel": false,
      "can_edit_note": false,
      "created_at": "2026-11-17T14:15:20.887166Z",
      "updated_at": "2026-11-20T14:15:20.935068Z",
      "items": [
        {
          "id": "9d88c841-1cc0-40cd-a511-3df424fe7beb",
          "menu_item_id": "16621f77-02ba-46c8-a73f-fa9c001264db",
          "item_name": "Ayam Bakar Rempah",
          "tenant_name": "Mangkuk Nusantara",
          "price": 43000,
          "quantity": 1,
          "subtotal": 43000
        }
      ]
    },
    {
      "id": "9dc7eaae-20c9-4ee9-a973-60e313828737",
      "order_code": "#DEMO-0008",
      "status": "delivered",
      "status_display": "Delivered",
      "packaging_type": "reusable",
      "packaging_display": "Reusable container",
      "reusable_returned": false,
      "reusable_containers": 1,
      "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
      "delivery_notes": "Data pesanan contoh untuk demonstrasi SustainaBowl.",
      "delivery_eta_minutes": 25,
      "subtotal": 45000,
      "packaging_fee": 5000,
      "delivery_fee": 7000,
      "total_price": 57000,
      "eco_points": 20,
      "total_items_count": 1,
      "can_cancel": false,
      "can_edit_note": false,
      "created_at": "2026-11-08T14:15:20.887166Z",
      "updated_at": "2026-11-20T14:15:20.953011Z",
      "items": [
        {
          "id": "dd33cd16-7d67-4fe3-b7de-059e99c9c86c",
          "menu_item_id": "31fb46bf-2ab8-4702-9665-4e816467407e",
          "item_name": "Grilled Tempeh Bowl",
          "tenant_name": "Greenhouse Kitchen",
          "price": 45000,
          "quantity": 1,
          "subtotal": 45000
        }
      ]
    },
    {
      "id": "fee083c9-53f8-4dd1-acca-1da44e695e71",
      "order_code": "#DEMO-0012",
      "status": "cancelled",
      "status_display": "Cancelled",
      "packaging_type": "reusable",
      "packaging_display": "Reusable container",
      "reusable_returned": false,
      "reusable_containers": 1,
      "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
      "delivery_notes": "Data pesanan contoh untuk demonstrasi SustainaBowl.",
      "delivery_eta_minutes": 25,
      "subtotal": 42000,
      "packaging_fee": 5000,
      "delivery_fee": 7000,
      "total_price": 54000,
      "eco_points": 20,
      "total_items_count": 1,
      "can_cancel": false,
      "can_edit_note": false,
      "created_at": "2026-10-06T14:15:20.887166Z",
      "updated_at": "2026-11-20T14:15:20.985751Z",
      "items": [
        {
          "id": "79d7a87f-5c0a-41b5-82f5-bbdaaed93b20",
          "menu_item_id": "48bf8a20-c62e-4b5c-9028-4eb142417de7",
          "item_name": "Low Carb Chicken Bowl",
          "tenant_name": "Greenhouse Kitchen",
          "price": 42000,
          "quantity": 1,
          "subtotal": 42000
        }
      ]
    }
  ]
}
''';

const cartResponse = r'''
{
  "id": "c72dd25b-fc2c-485c-98fc-6f602e554759",
  "total_items": 6,
  "tenant_count": 3,
  "subtotal": 246000,
  "items": [
    {
      "id": "7392e0aa-9fa5-4c8d-8a04-88b4ed6e5898",
      "menu_item_id": "31fb46bf-2ab8-4702-9665-4e816467407e",
      "name": "Grilled Tempeh Bowl",
      "tenant_name": "Greenhouse Kitchen",
      "tenant_area": "Beji",
      "price": 45000,
      "photo_url": null,
      "quantity": 4,
      "subtotal": 180000
    },
    {
      "id": "328ee798-3aa2-4f78-897f-fddb9c868268",
      "menu_item_id": "de82a5cb-2dbd-4ece-bd12-bc3a1f79ee5d",
      "name": "Garden Quinoa Bowl",
      "tenant_name": "Kebun Salad",
      "tenant_area": "Pancoran Mas",
      "price": 41000,
      "photo_url": null,
      "quantity": 1,
      "subtotal": 41000
    },
    {
      "id": "04a83dc6-d310-44c0-a463-018f62df18ec",
      "menu_item_id": "46692a1d-f4a1-40ee-84ad-ca8354869abd",
      "name": "Berry Chia Pudding",
      "tenant_name": "Berry Baik",
      "tenant_area": "Tanah Baru",
      "price": 25000,
      "photo_url": null,
      "quantity": 1,
      "subtotal": 25000
    }
  ]
}
''';

const checkoutResponse = r'''
{
  "cart": {
    "id": "c72dd25b-fc2c-485c-98fc-6f602e554759",
    "total_items": 5,
    "tenant_count": 3,
    "subtotal": 201000,
    "items": [
      {
        "id": "7392e0aa-9fa5-4c8d-8a04-88b4ed6e5898",
        "menu_item_id": "31fb46bf-2ab8-4702-9665-4e816467407e",
        "name": "Grilled Tempeh Bowl",
        "tenant_name": "Greenhouse Kitchen",
        "tenant_area": "Beji",
        "price": 45000,
        "photo_url": null,
        "quantity": 3,
        "subtotal": 135000
      },
      {
        "id": "328ee798-3aa2-4f78-897f-fddb9c868268",
        "menu_item_id": "de82a5cb-2dbd-4ece-bd12-bc3a1f79ee5d",
        "name": "Garden Quinoa Bowl",
        "tenant_name": "Kebun Salad",
        "tenant_area": "Pancoran Mas",
        "price": 41000,
        "photo_url": null,
        "quantity": 1,
        "subtotal": 41000
      },
      {
        "id": "04a83dc6-d310-44c0-a463-018f62df18ec",
        "menu_item_id": "46692a1d-f4a1-40ee-84ad-ca8354869abd",
        "name": "Berry Chia Pudding",
        "tenant_name": "Berry Baik",
        "tenant_area": "Tanah Baru",
        "price": 25000,
        "photo_url": null,
        "quantity": 1,
        "subtotal": 25000
      }
    ]
  },
  "addresses": [
    {
      "id": 1,
      "label": "Rumah",
      "recipient_name": "Alya Pratama",
      "phone_number": "081311112222",
      "address": "Jl. Margonda Raya No. 12, Depok",
      "landmark": "Pagar hijau dekat minimarket",
      "is_default": true,
      "delivery_fee": 7000,
      "eta_minutes": 25
    },
    {
      "id": 2,
      "label": "Kampus",
      "recipient_name": "Alya Pratama",
      "phone_number": "081311112222",
      "address": "Fasilkom UI, Kampus Depok",
      "landmark": "Lobi gedung baru",
      "is_default": false,
      "delivery_fee": 7000,
      "eta_minutes": 25
    }
  ],
  "default_address_id": 1,
  "packaging_options": [
    {
      "value": "reusable",
      "label": "Reusable container",
      "description": "Return it on your next order. Deposit refunded.",
      "fee": 5000,
      "formatted_fee": "Rp 5.000",
      "eco_points": 20,
      "disabled": false
    },
    {
      "value": "compostable",
      "label": "Compostable box",
      "description": "Plant-fibre box. Breaks down in home compost.",
      "fee": 2000,
      "formatted_fee": "Rp 2.000",
      "eco_points": 10,
      "disabled": false
    }
  ]
}
''';

const placedOrderResponse = r'''
{
  "id": "3c5dc46d-acbc-45ca-928b-8cc9a02c194e",
  "order_code": "#SB-261120-1861",
  "status": "pending",
  "status_display": "Pending",
  "packaging_type": "compostable",
  "packaging_display": "Compostable box",
  "reusable_returned": false,
  "reusable_containers": 0,
  "delivery_address": "Rumah: Alya Pratama (081311112222)\nJl. Margonda Raya No. 12, Depok\nPatokan: Pagar hijau dekat minimarket",
  "delivery_notes": "Titip satpam",
  "delivery_eta_minutes": 25,
  "subtotal": 201000,
  "packaging_fee": 2000,
  "delivery_fee": 7000,
  "total_price": 210000,
  "eco_points": 10,
  "total_items_count": 5,
  "can_cancel": true,
  "can_edit_note": true,
  "created_at": "2026-11-20T14:16:05.365260Z",
  "updated_at": "2026-11-20T14:16:05.365407Z",
  "items": [
    {
      "id": "2a174c12-1144-413a-91d0-83367e2819ae",
      "menu_item_id": "31fb46bf-2ab8-4702-9665-4e816467407e",
      "item_name": "Grilled Tempeh Bowl",
      "tenant_name": "Greenhouse Kitchen",
      "price": 45000,
      "quantity": 3,
      "subtotal": 135000
    },
    {
      "id": "f8bd7618-63d7-488c-905a-b5713b7ec295",
      "menu_item_id": "de82a5cb-2dbd-4ece-bd12-bc3a1f79ee5d",
      "item_name": "Garden Quinoa Bowl",
      "tenant_name": "Kebun Salad",
      "price": 41000,
      "quantity": 1,
      "subtotal": 41000
    },
    {
      "id": "57c68a5b-81d7-4010-9169-d20a020a80ba",
      "menu_item_id": "46692a1d-f4a1-40ee-84ad-ca8354869abd",
      "item_name": "Berry Chia Pudding",
      "tenant_name": "Berry Baik",
      "price": 25000,
      "quantity": 1,
      "subtotal": 25000
    }
  ]
}
''';
