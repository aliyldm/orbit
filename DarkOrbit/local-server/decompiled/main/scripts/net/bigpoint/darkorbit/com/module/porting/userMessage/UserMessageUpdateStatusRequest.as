package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageUpdateStatusRequest implements IModule
   {
      
      private static var _instance:UserMessageUpdateStatusRequest;
      
      public var inbox:Boolean = false;
      
      public var status:int = 0;
      
      public var ids:Vector.<Number>;
      
      public function UserMessageUpdateStatusRequest(param1:Vector.<Number> = null, param2:Boolean = false, param3:int = 0)
      {
         super();
         this.inbox = param2;
         this.status = param3;
         if(param1 == null)
         {
            this.ids = new Vector.<Number>();
         }
         else
         {
            this.ids = param1;
         }
      }
      
      public static function get instance() : UserMessageUpdateStatusRequest
      {
         return _instance || (_instance = new UserMessageUpdateStatusRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26787;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inbox = param1.readBoolean();
         this.status = param1.readInt();
         this.status = this.status << 8 % 32 | this.status >>> 32 - 8 % 32;
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
         param1.writeShort(26787);
         param1.writeBoolean(this.inbox);
         param1.writeInt(this.status >>> 8 % 32 | this.status << 32 - 8 % 32);
         param1.writeByte(this.ids.length);
         for each(_loc2_ in this.ids)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

