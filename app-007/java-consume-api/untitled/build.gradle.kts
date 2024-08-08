
plugins {
	java
	id("org.springframework.boot") version "3.3.1"
	id("io.spring.dependency-management") version "1.1.5"

	// SOAP https://www.baeldung.com/java-gradle-create-wsdl-stubs
	id("com.github.bjornvester.wsdl2java") version "2.0.2"
}



group = "digital.alf"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(21)
	}
}

configurations {
	compileOnly {
		extendsFrom(configurations.annotationProcessor.get())
	}
}

repositories {
	mavenCentral()
}

extra["springCloudAzureVersion"] = "5.13.0"

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-data-rest")
	implementation("com.azure.spring:spring-cloud-azure-starter")
	implementation("org.springframework.boot:spring-boot-starter-web-services")
	implementation("com.azure.spring:spring-cloud-azure-starter-active-directory")
	compileOnly("org.projectlombok:lombok")
	annotationProcessor("org.projectlombok:lombok")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("org.springframework.boot:spring-boot-testcontainers")
	testImplementation("org.testcontainers:junit-jupiter")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")

	// SOAP and xml
	implementation("jakarta.xml.ws:jakarta.xml.ws-api:3.0.0")
	runtimeOnly("com.sun.xml.ws:jaxws-rt:3.0.0")
	implementation("com.sun.xml.ws:jaxws-tools:2.1.4")

	implementation("com.sun.xml.ws:jaxws-rt:3.0.2") // Replace with the latest compatible version
}


dependencyManagement {
	imports {
		mavenBom("com.azure.spring:spring-cloud-azure-dependencies:${property("springCloudAzureVersion")}")
	}
}

tasks.withType<Test> {
	useJUnitPlatform()
}

tasks.bootRun {
	systemProperties["server.port"] = "7080"
}

tasks.wsdl2java {
	sourcesOutputDir.set(layout.projectDirectory.dir("src/generated/wsdl2java"))
	packageName.set("digital.alf")
}

tasks.withType<Jar>() {

	duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}