module.exports = ({ config }) => ({
  ...config,
    slug: "screentime-expo",
    extra: {
      eas: {
        projectId: "4d563055-9602-4983-942f-57edeec3d0a3"
      }
    },
    ios: {
        bundleIdentifier: "com.test.screentime.expo",
        buildNumber: "1"
    },
    android: {
        package: "com.test.screentime.expo",
        versionCode: 1
    }
  });