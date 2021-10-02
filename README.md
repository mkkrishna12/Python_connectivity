# Python_connectivity


We are connecting flutter with python using chaquopy 0.0.11.This is a chaquopy plugin to run python code on android. This is the simplest version, where you can write you code and run it.

Configuration Steps : 
Add maven { url "https://chaquo.com/maven" } and add chaquopy dependency in dependencies section at project level gradle.build like following :

buildscript {
    repositories {
        google()
        jcenter()
        maven { url "https://chaquo.com/maven" }
    }
    dependencies {
        ...
        classpath "com.chaquo.python:gradle:9.1.0"
    }
}
Then, in the module-level build.gradle file (usually in the app directory), apply the Chaquopy plugin at the top of the file, but after the Android plugin:

apply plugin: 'com.android.application' 
apply plugin: 'com.chaquo.python' 
Apply ABI selection using following code.

defaultConfig {
    ndk {
       abiFilters "armeabi-v7a", "arm64-v8a", "x86", "x86_64"
    }
}
After that sync your project.
