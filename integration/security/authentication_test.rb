# encoding: utf-8

#--
# Copyright 2013-2014 DataStax, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++

require File.dirname(__FILE__) + '/../integration_test_case.rb'

class AuthenticationTest < IntegrationTestCase
  def setup
    @username, @password = ccm_cluster.enable_authentication
  end

  def teardown
    ccm_cluster.disable_authentication
  end

  def test_can_authenticate_to_cluster
    cluster = Cassandra.connect(
                username: @username,
                password: @password
              )

    refute_nil cluster
  end

  def test_raise_error_on_invalid_auth
    assert_raises(ArgumentError) do
      cluster = Cassandra.connect(
                  username: '',
                  password: ''
                )
    end

    assert_raises(Cassandra::Errors::AuthenticationError) do
      cluster = Cassandra.connect(
                  username: 'invalidname',
                  password: 'badpassword'
                )
    end
  end
end