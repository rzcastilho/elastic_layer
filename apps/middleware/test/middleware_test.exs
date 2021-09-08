defmodule MiddlewareTest do
  use ExUnit.Case
  use Plug.Test
  
  import Mox
  import Payload
  
  setup :verify_on_exit!
  
  @base "/index/_search"
  @options Middleware.init([])
  @headers [{"content-type", "application/json"}]
  
  @tag :mock
  test "get should be succeeded with cacheable flag true and no search_id" do
    
    expect(Elastix.HTTPMock, :request!, fn "GET", _, _, _, _ -> %HTTPoison.Response{body: response("rances-unglues"), headers: @headers, status_code: 200} end)
    
    conn =
      :get
      |> conn("#{@base}?q=name.keyword:rances-unglues")
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id == nil
    assert conn.assigns.search_request.ignore_cache? == false
    assert conn.assigns.search_request.ttl == 300_000
    assert Jason.decode!(conn.resp_body) == response("rances-unglues")
  end
  
  @tag :mock
  test "post should be succeeded with cacheable flag true and search_id" do
    
    expect(Elastix.HTTPMock, :request!, fn "POST", _, _, _, _ -> %HTTPoison.Response{body: response("rances-unglues"), headers: @headers, status_code: 200} end)
    
    conn =
      :post
      |> conn(@base, request("rances-unglues"))
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id != nil
    assert conn.assigns.search_request.ignore_cache? == false
    assert conn.assigns.search_request.ttl == 300_000
    assert Jason.decode!(conn.resp_body) == response("rances-unglues")
  end
  
  @tag :mock
  test "get with nocache should be succeeded with cacheable flag true, no search_id and ignore_cache? equals true" do
    
    expect(Elastix.HTTPMock, :request!, fn "GET", _, _, _, _ -> %HTTPoison.Response{body: response("papish-meeken"), headers: @headers, status_code: 200} end)
    
    conn =
      :get
      |> conn("#{@base}?q=name.keyword:papish-meeken&nocache")
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id == nil
    assert conn.assigns.search_request.ignore_cache? == true
    assert conn.assigns.search_request.ttl == 300_000
    assert Jason.decode!(conn.resp_body) == response("papish-meeken")
  end
  
  @tag :mock
  test "post with nocache should be succeeded with cacheable flag true, search_id and ignore_cache? equals true" do
    
    expect(Elastix.HTTPMock, :request!, fn "POST", _, _, _, _ -> %HTTPoison.Response{body: response("papish-meeken"), headers: @headers, status_code: 200} end)
    
    conn =
      :post
      |> conn("#{@base}?nocache", request("papish-meeken"))
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id != nil
    assert conn.assigns.search_request.ignore_cache? == true
    assert conn.assigns.search_request.ttl == 300_000
    assert Jason.decode!(conn.resp_body) == response("papish-meeken")
  end
  
  @tag :mock
  test "get with custom ttl should be succeeded with cacheable flag true, no search_id and informed ttl" do
    
    expect(Elastix.HTTPMock, :request!, fn "GET", _, _, _, _ -> %HTTPoison.Response{body: response("uncurrent-readvise"), headers: @headers, status_code: 200} end)
    
    conn =
      :get
      |> conn("#{@base}?q=name.keyword:uncurrent-readvise&ttl=60000")
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id == nil
    assert conn.assigns.search_request.ignore_cache? == false
    assert conn.assigns.search_request.ttl == 60_000
    assert Jason.decode!(conn.resp_body) == response("uncurrent-readvise")
  end
  
  @tag :mock
  test "post with custom ttl should be succeeded with cacheable flag true, search_id and informed ttl" do
    
    expect(Elastix.HTTPMock, :request!, fn "POST", _, _, _, _ -> %HTTPoison.Response{body: response("uncurrent-readvise"), headers: @headers, status_code: 200} end)
    
    conn =
      :post
      |> conn("#{@base}?ttl=60000", request("uncurrent-readvise"))
      |> Middleware.call(@options)
      
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.assigns.search_request.cacheable? == true
    assert conn.assigns.search_request.search_id != nil
    assert conn.assigns.search_request.ignore_cache? == false
    assert conn.assigns.search_request.ttl == 60_000
    assert Jason.decode!(conn.resp_body) == response("uncurrent-readvise")
  end
  
end
