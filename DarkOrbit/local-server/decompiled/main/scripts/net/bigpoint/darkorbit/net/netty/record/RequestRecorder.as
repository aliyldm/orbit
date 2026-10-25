package net.bigpoint.darkorbit.net.netty.record
{
   import net.bigpoint.com.module.IModule;
   
   public class RequestRecorder extends AbstractRecorder
   {
      
      public static const INSTANCE:RequestRecorder = new RequestRecorder();
      
      public static const requestBlackFilterList:Array = ["VersionRequest","ObfuscationRequest","HandshakeRequest","LoginRequest","KeepAlive","TrackVariableRequest","UserKeyBindingsUpdate","AudioSettingsRequest"];
      
      private static const API_WAIT_COMMAND_THRESHOLD:uint = 20;
      
      public function RequestRecorder()
      {
         super();
      }
      
      override protected function get blackFilterList() : Array
      {
         return RequestRecorder.requestBlackFilterList;
      }
      
      public function record(param1:IModule) : void
      {
         var _loc2_:RecordVO = new RecordVO();
         _loc2_.isRequest = true;
         super._record(param1,_loc2_);
      }
      
      override protected function createOutput(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc5_:RecordVO = null;
         var _loc6_:uint = 0;
         param1 += "- REQUESTS start --------------------------------------------------\n";
         var _loc3_:RecordVO = null;
         var _loc4_:RecordVO = null;
         for each(_loc5_ in records)
         {
            _loc3_ = _loc5_;
            if(_loc3_.params.length > 0)
            {
               _loc2_ = "API.sendRequest(" + _loc3_.clazzname + "," + _loc3_.params + ");";
            }
            else
            {
               _loc2_ = "API.sendRequest(" + _loc3_.clazzname + ");";
            }
            param1 += _loc2_ + "\n";
            if(_loc4_ != null)
            {
               _loc6_ = Number(_loc3_.timestamp) - Number(_loc4_.timestamp);
               if(_loc6_ > API_WAIT_COMMAND_THRESHOLD)
               {
                  _loc2_ = "API.wait(" + _loc6_ + ");";
                  param1 += _loc2_ + "\n";
               }
            }
            _loc4_ = _loc3_;
         }
         return param1;
      }
   }
}

