const request = require("supertest");
const app = require("../../../app"); // Adjust the path to your app

describe("GET /api/products", () => {
  it("should return a list of products", async () => {
    const response = await request(app).get("/api/products");
    expect(response.status).toBe(200);
    expect(response.body).toBeInstanceOf(Array);
  });
});

describe("GET /api/products/:id", () => {
  it("should return a single product by ID", async () => {
    const productId = 1; // Adjust the ID based on your test data
    const response = await request(app).get(`/api/products/${productId}`);
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("id", productId);
  });

  it("should return 404 if product is not found", async () => {
    const productId = 9999; // Adjust the ID to a non-existent product
    const response = await request(app).get(`/api/products/${productId}`);
    expect(response.status).toBe(404);
  });
});

describe("POST /api/products", () => {
  it("should create a new product", async () => {
    const newProduct = { name: "New Product", price: 100 };
    const response = await request(app).post("/api/products").send(newProduct);
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty("id");
    expect(response.body).toHaveProperty("name", newProduct.name);
    expect(response.body).toHaveProperty("price", newProduct.price);
  });

  it("should return 400 if data is invalid", async () => {
    const invalidProduct = { name: "" }; // Invalid data
    const response = await request(app)
      .post("/api/products")
      .send(invalidProduct);
    expect(response.status).toBe(400);
  });
});

describe("PUT /api/products/:id", () => {
  it("should update an existing product", async () => {
    const productId = 1; // Adjust the ID based on your test data
    const updatedProduct = { name: "Updated Product", price: 150 };
    const response = await request(app)
      .put(`/api/products/${productId}`)
      .send(updatedProduct);
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("id", productId);
    expect(response.body).toHaveProperty("name", updatedProduct.name);
    expect(response.body).toHaveProperty("price", updatedProduct.price);
  });

  it("should return 404 if product is not found", async () => {
    const productId = 9999; // Adjust the ID to a non-existent product
    const updatedProduct = { name: "Updated Product", price: 150 };
    const response = await request(app)
      .put(`/api/products/${productId}`)
      .send(updatedProduct);
    expect(response.status).toBe(404);
  });
});

describe("DELETE /api/products/:id", () => {
  it("should delete an existing product", async () => {
    const productId = 1; // Adjust the ID based on your test data
    const response = await request(app).delete(`/api/products/${productId}`);
    expect(response.status).toBe(200);
  });

  it("should return 404 if product is not found", async () => {
    const productId = 9999; // Adjust the ID to a non-existent product
    const response = await request(app).delete(`/api/products/${productId}`);
    expect(response.status).toBe(404);
  });
});
