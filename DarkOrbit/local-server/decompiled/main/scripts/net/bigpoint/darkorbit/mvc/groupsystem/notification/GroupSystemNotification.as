package net.bigpoint.darkorbit.mvc.groupsystem.notification
{
   public class GroupSystemNotification
   {
      
      private static const NAME:String = "GroupSystemNotification";
      
      public static const UPDATE_UI:String = NAME + "UPDATE_UI";
      
      public static const CHANGE_SHIP_GROUP_STATE:String = NAME + "CHANGE_SHIP_GROUP_STATE";
      
      public static const REMOVE_MEMBER_CLIP:String = NAME + "REMOVE_MEMBER_CLIP";
      
      public static const ADD_INVITATION:String = NAME + "ADD_INVITATION";
      
      public static const REMOVE_INVITATION_UI:String = NAME + "REMOVE_INVITATION_UI";
      
      public static const UPDATE_BLOCK_INVITATION_STATE:String = NAME + "UPDATE_BLOCK_INVITATION_STATE";
      
      public static const UPDATE_UI_PING_MODE:String = NAME + "UPDATE_UI_PING_MODE";
      
      public static const CLEANUP:String = NAME + "CLEANUP";
      
      public static const UPDATE_MODEL_PING_STATE:String = NAME + "UPDATE_MODEL_PING_STATE";
      
      public static const PREPARE_USER:String = NAME + "PREPARE_USER";
      
      public static const RELATED_DATA_CHANGED:String = NAME + "RELATED_DATA_CHANGED";
      
      public static const CLEANUP_UI:String = NAME + "CLEANUP_UI";
      
      public static const REMOVE_INVITATION_BY_MEMBER_ID:String = NAME + "REMOVE_INVITATION_BY_MEMBER_ID";
      
      public static const INIT_GROUP:String = NAME + "INIT_GROUP";
      
      public static const TERMINATE_GROUP:String = NAME + "TERMINATE_GROUP";
      
      public function GroupSystemNotification()
      {
         super();
      }
   }
}

