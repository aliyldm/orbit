package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageLootRequest implements IModule
   {
      
      private static var _instance:UserMessageLootRequest;
      
      public var ids:Vector.<Number>;
      
      public function UserMessageLootRequest(param1:Vector.<Number> = null)
      {
         super();
         if(param1 == null)
         {
            this.ids = new Vector.<Number>();
         }
         else
         {
            this.ids = param1;
         }
      }
      
      public static function get instance() : UserMessageLootRequest
      {
         return _instance || (_instance = new UserMessageLootRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11902;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ids.length > 0)
         {
            this.ids.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.ids.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-11902);
         param1.writeByte(this.ids.length);
         for each(_loc2_ in this.ids)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

