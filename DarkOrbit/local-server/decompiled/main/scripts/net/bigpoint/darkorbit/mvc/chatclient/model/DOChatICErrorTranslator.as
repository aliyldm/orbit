package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.ICErrorType;
   import com.bigpoint.utils.StringPair;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class DOChatICErrorTranslator
   {
      
      private static const customErrors:Vector.<StringPair> = new <StringPair>[new StringPair("user no longer logged in",BPLocale.getItemInCategory("chat","dochat.chat.inviteErrorUserNotFound")),new StringPair("Not creator of this channel",BPLocale.getItemInCategory("chat","dochat.chat.inviteErrorNotYourRoom")),new StringPair("no playerId found",BPLocale.getItemInCategory("chat","dochat.chat.inviteErrorUserNotFound"))];
      
      private static const errorMap:Object = {};
      
      errorMap[ICErrorType.TimedOut] = BPLocale.getItemInCategory("chat","error_timedout");
      errorMap[ICErrorType.RightsCheck] = BPLocale.getItemInCategory("chat","error_rightscheck");
      errorMap[ICErrorType.CouldNotLoginWithoutCredentials] = BPLocale.getItemInCategory("chat","error_couldnotloginwithoutcredentials");
      errorMap[ICErrorType.CouldNotLoginWithWrongCredentials] = BPLocale.getItemInCategory("chat","error_couldnotloginwithwrongcredentials");
      errorMap[ICErrorType.NoServer] = BPLocale.getItemInCategory("chat","error_noserver");
      errorMap[ICErrorType.InternalError] = BPLocale.getItemInCategory("chat","error_internalerror");
      errorMap[ICErrorType.ParseFailed] = BPLocale.getItemInCategory("chat","error_parsefailed");
      errorMap[ICErrorType.SendLimitReached] = BPLocale.getItemInCategory("chat","dochat.chat.spamWarning");
      
      public function DOChatICErrorTranslator()
      {
         super();
      }
      
      public static function getTranslation(param1:ICError) : String
      {
         if(!param1)
         {
            return null;
         }
         if(param1.errorType == ICErrorType.Custom)
         {
            return getCustomErrorTranslation(param1);
         }
         return errorMap[param1.errorType] || null;
      }
      
      private static function getCustomErrorTranslation(param1:ICError) : String
      {
         var _loc4_:StringPair = null;
         var _loc2_:int = int(customErrors.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = customErrors[_loc3_];
            if(param1.message.indexOf(_loc4_.left) != -1)
            {
               return _loc4_.right;
            }
            _loc3_++;
         }
         return BPLocale.getItemInCategory("chat","error_custom") + " [" + param1.message + "]";
      }
   }
}

