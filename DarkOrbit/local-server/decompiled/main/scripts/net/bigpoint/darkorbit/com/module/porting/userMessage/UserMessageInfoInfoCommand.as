package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class UserMessageInfoInfoCommand extends AbsUserMessageInfoCommand
   {
      
      private static var _instance:UserMessageInfoInfoCommand;
      
      public function UserMessageInfoInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "")
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
      }
      
      public static function get instance() : UserMessageInfoInfoCommand
      {
         return _instance || (_instance = new UserMessageInfoInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 18565;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18565);
         super.write(param1);
      }
   }
}

