package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageDeleteRequest implements IModule
   {
      
      private static var _instance:UserMessageDeleteRequest;
      
      public var inbox:Boolean = false;
      
      public var deleteIds:Vector.<Number>;
      
      public function UserMessageDeleteRequest(param1:Vector.<Number> = null, param2:Boolean = false)
      {
         super();
         this.inbox = param2;
         if(param1 == null)
         {
            this.deleteIds = new Vector.<Number>();
         }
         else
         {
            this.deleteIds = param1;
         }
      }
      
      public static function get instance() : UserMessageDeleteRequest
      {
         return _instance || (_instance = new UserMessageDeleteRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21683;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inbox = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.deleteIds.length > 0)
         {
            this.deleteIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.deleteIds.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-21683);
         param1.writeBoolean(this.inbox);
         param1.writeByte(this.deleteIds.length);
         for each(_loc2_ in this.deleteIds)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

