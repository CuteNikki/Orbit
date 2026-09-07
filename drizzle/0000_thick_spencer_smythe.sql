CREATE TABLE "account" (
	"id" text PRIMARY KEY NOT NULL,
	"accountId" text NOT NULL,
	"providerId" text NOT NULL,
	"userId" text NOT NULL,
	"accessToken" text,
	"refreshToken" text,
	"idToken" text,
	"accessTokenExpiresAt" timestamp,
	"refreshTokenExpiresAt" timestamp,
	"scope" text,
	"issuer" text,
	"password" text,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"updatedAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ban" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" text NOT NULL,
	"bannedById" text NOT NULL,
	"reason" text NOT NULL,
	"expiresAt" timestamp,
	"ipAddress" text,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"liftedAt" timestamp,
	"liftedById" text,
	"liftReason" text
);
--> statement-breakpoint
CREATE TABLE "banned_ip" (
	"id" text PRIMARY KEY NOT NULL,
	"ipAddress" text NOT NULL,
	"reason" text NOT NULL,
	"bannedById" text NOT NULL,
	"userId" text,
	"expiresAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"liftedAt" timestamp,
	"liftedById" text,
	"liftReason" text
);
--> statement-breakpoint
CREATE TABLE "chat" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"name" text,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"endedAt" timestamp,
	"deletedAt" timestamp
);
--> statement-breakpoint
CREATE TABLE "chat_participant" (
	"id" text PRIMARY KEY NOT NULL,
	"chatId" text NOT NULL,
	"userId" text NOT NULL,
	"joinedAt" timestamp DEFAULT now() NOT NULL,
	"leftAt" timestamp,
	"clearedAt" timestamp
);
--> statement-breakpoint
CREATE TABLE "interest" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" text NOT NULL,
	"tag" text NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "invite" (
	"id" text PRIMARY KEY NOT NULL,
	"senderId" text NOT NULL,
	"receiverId" text NOT NULL,
	"status" text DEFAULT 'PENDING' NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"respondedAt" timestamp,
	"chatId" text
);
--> statement-breakpoint
CREATE TABLE "message" (
	"id" text PRIMARY KEY NOT NULL,
	"chatId" text NOT NULL,
	"senderId" text NOT NULL,
	"kind" text DEFAULT 'USER' NOT NULL,
	"meta" jsonb,
	"content" text,
	"imageUrl" text,
	"replyToId" text,
	"editedAt" timestamp,
	"deletedAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification" (
	"id" text PRIMARY KEY NOT NULL,
	"recipientId" text NOT NULL,
	"actorId" text NOT NULL,
	"type" text NOT NULL,
	"targetId" text NOT NULL,
	"metadata" jsonb,
	"readAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"updatedAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "post" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" text NOT NULL,
	"imageUrl" text,
	"caption" text,
	"deletedAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "post_hashtag" (
	"id" text PRIMARY KEY NOT NULL,
	"postId" text NOT NULL,
	"tag" text NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "post_like" (
	"id" text PRIMARY KEY NOT NULL,
	"postId" text NOT NULL,
	"userId" text NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "random_queue" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" text NOT NULL,
	"joinedAt" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "random_queue_userId_unique" UNIQUE("userId")
);
--> statement-breakpoint
CREATE TABLE "report" (
	"id" text PRIMARY KEY NOT NULL,
	"reporterId" text NOT NULL,
	"reportedUserId" text NOT NULL,
	"chatId" text,
	"messageId" text,
	"postId" text,
	"reason" text,
	"reference" text,
	"status" text DEFAULT 'PENDING' NOT NULL,
	"verdict" text,
	"reviewedById" text,
	"reviewedAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "session" (
	"id" text PRIMARY KEY NOT NULL,
	"expiresAt" timestamp NOT NULL,
	"token" text NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"updatedAt" timestamp DEFAULT now() NOT NULL,
	"ipAddress" text,
	"userAgent" text,
	"userId" text NOT NULL,
	CONSTRAINT "session_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "user" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"emailVerified" boolean DEFAULT false NOT NULL,
	"image" text,
	"username" text NOT NULL,
	"bio" text,
	"role" text DEFAULT 'MEMBER' NOT NULL,
	"notificationPrefs" text,
	"friendsOnlyPosts" boolean DEFAULT false NOT NULL,
	"isBanned" boolean DEFAULT false NOT NULL,
	"banExpiresAt" timestamp,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"updatedAt" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "user_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "verification" (
	"id" text PRIMARY KEY NOT NULL,
	"identifier" text NOT NULL,
	"value" text NOT NULL,
	"expiresAt" timestamp NOT NULL,
	"createdAt" timestamp DEFAULT now(),
	"updatedAt" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "account" ADD CONSTRAINT "account_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "session" ADD CONSTRAINT "session_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "ban_user_created_idx" ON "ban" USING btree ("userId","createdAt");--> statement-breakpoint
CREATE INDEX "ban_user_active_idx" ON "ban" USING btree ("userId","liftedAt");--> statement-breakpoint
CREATE INDEX "banned_ip_active_idx" ON "banned_ip" USING btree ("ipAddress","liftedAt");--> statement-breakpoint
CREATE UNIQUE INDEX "chat_participant_chat_user_unique" ON "chat_participant" USING btree ("chatId","userId");--> statement-breakpoint
CREATE INDEX "chat_participant_chat_left_idx" ON "chat_participant" USING btree ("chatId","leftAt");--> statement-breakpoint
CREATE UNIQUE INDEX "interest_user_tag_unique" ON "interest" USING btree ("userId","tag");--> statement-breakpoint
CREATE INDEX "interest_tag_idx" ON "interest" USING btree ("tag");--> statement-breakpoint
CREATE INDEX "invite_receiver_status_idx" ON "invite" USING btree ("receiverId","status");--> statement-breakpoint
CREATE INDEX "message_chat_created_idx" ON "message" USING btree ("chatId","createdAt");--> statement-breakpoint
CREATE UNIQUE INDEX "notification_dedupe_unique" ON "notification" USING btree ("recipientId","actorId","type","targetId");--> statement-breakpoint
CREATE INDEX "notification_recipient_created_idx" ON "notification" USING btree ("recipientId","createdAt");--> statement-breakpoint
CREATE INDEX "notification_recipient_read_idx" ON "notification" USING btree ("recipientId","readAt");--> statement-breakpoint
CREATE INDEX "post_user_created_idx" ON "post" USING btree ("userId","createdAt");--> statement-breakpoint
CREATE UNIQUE INDEX "post_hashtag_post_tag_unique" ON "post_hashtag" USING btree ("postId","tag");--> statement-breakpoint
CREATE INDEX "post_hashtag_tag_idx" ON "post_hashtag" USING btree ("tag");--> statement-breakpoint
CREATE UNIQUE INDEX "post_like_post_user_unique" ON "post_like" USING btree ("postId","userId");--> statement-breakpoint
CREATE UNIQUE INDEX "user_username_unique" ON "user" USING btree ("username");