package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class UserMessageSystemInfoCommand extends AbsUserMessageInfoCommand
   {
      
      private static var _instance:UserMessageSystemInfoCommand;
      
      public var strs:Vector.<String>;
      
      public function UserMessageSystemInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "", param13:Vector.<String> = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(param13 == null)
         {
            this.strs = new Vector.<String>();
         }
         else
         {
            this.strs = param13;
         }
      }
      
      public static function get instance() : UserMessageSystemInfoCommand
      {
         return _instance || (_instance = new UserMessageSystemInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 18192;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.strs.length > 0)
         {
            this.strs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.strs.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(18192);
         super.write(param1);
         param1.writeByte(this.strs.length);
         for each(_loc2_ in this.strs)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

