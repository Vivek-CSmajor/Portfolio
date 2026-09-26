---
title: "What I Learned Building SIP/VoIP Integrations"
date: 2026-05-20
teaser: "Notes from wiring up monitoring for real-time call infrastructure — the parts the RFC doesn't warn you about."
---

## The RFC Doesn't Cover Vendor Behavior

SIP looks simple on paper — INVITE, 200 OK, ACK — until you're the one debugging why a call dropped for one specific carrier route at 2am. The RFC tells you the state machine; it does not tell you which vendors interpret re-INVITEs differently.

## Monitoring the Media Layer, Not Just Signaling

The monitoring that actually caught problems before customers did was less about SIP signaling and more about the media layer: RTP packet loss, jitter, and one-way-audio detection. Alerting on call-setup failures alone missed an entire class of "the call connected but was unusable" incidents.

## The Biggest Lesson

Treat every third-party SIP trunk as if it will violate the spec in some small way, and build monitoring that surfaces that violation quickly rather than trying to preemptively handle every vendor's quirks in code.
