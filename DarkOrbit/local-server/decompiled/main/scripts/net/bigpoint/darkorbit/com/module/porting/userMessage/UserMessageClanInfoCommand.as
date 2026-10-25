package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class UserMessageClanInfoCommand extends AbsUserMessageInfoCommand
   {
      
      private static var _instance:UserMessageClanInfoCommand;
      
      public var clanTag:String = "";
      
      public var parentMessage:UserMessageParentInfoCommand;
      
      public var senderName:String = "";
      
      public function UserMessageClanInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "", param13:String = "", param14:String = "", param15:UserMessageParentInfoCommand = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         this.clanTag = param13;
         if(param15 == null)
         {
            this.parentMessage = new UserMessageParentInfoCommand();
         }
         else
         {
            this.parentMessage = param15;
         }
         this.senderName = param14;
      }
      
      public static function get instance() : UserMessageClanInfoCommand
      {
         return _instance || (_instance = new UserMessageClanInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -19457;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.clanTag = param1.readUTF();
         this.parentMessage = UserMessageParentInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.parentMessage)
         {
            this.parentMessage.read(param1);
         }
         this.senderName = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19457);
         super.write(param1);
         param1.writeUTF(this.clanTag);
         if(null != this.parentMessage)
         {
            this.parentMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.senderName);
      }
   }
}

