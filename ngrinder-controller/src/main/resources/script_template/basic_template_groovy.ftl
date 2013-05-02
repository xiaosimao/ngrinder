package org.ngrinder;

import static net.grinder.script.Grinder.grinder
import static org.junit.Assert.*
import static org.hamcrest.Matchers.*
import net.grinder.plugin.http.HTTPRequest
import net.grinder.script.GTest
import net.grinder.script.Grinder
import net.grinder.scriptengine.groovy.junit.GrinderRunner
import net.grinder.scriptengine.groovy.junit.annotation.BeforeProcess
import net.grinder.scriptengine.groovy.junit.annotation.BeforeThread

import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import HTTPClient.HTTPResponse

@RunWith(GrinderRunner)
class MyTest {
	public static GTest test;
	public static HTTPRequest request;

	@BeforeProcess
	public static void beforeProcess() {
		test = new GTest(1, "Hello");
		request = new HTTPRequest();
		test.record(request);
		grinder.getLogger().info("before class in MyTest.");
	}

	@BeforeThread 
	public void beforeThread() {
		grinder.statistics.delayReports=true;
		grinder.getLogger().info("before thread in MyTest.");
	}

	@Test
	public void testHello(){
		HTTPResponse result = request.GET("${url}");

		if (result.statusCode == 301 || result.statusCode == 302) {
			grinder.logger.warn("Warning. The response may not be correct. The response code was {}.", result.statusCode); 
		} else {
			assertThat(result.statusCode, is(200));
		}
	}
}
