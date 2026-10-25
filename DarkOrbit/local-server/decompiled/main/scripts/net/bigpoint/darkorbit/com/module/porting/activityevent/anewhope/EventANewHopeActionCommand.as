package net.bigpoint.darkorbit.com.module.porting.activityevent.anewhope
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class EventANewHopeActionCommand implements IModule
   {
      
      private static var _instance:EventANewHopeActionCommand;
      
      public static const RETURNTYPE_ERROR:int = 0;
      
      public static const RETURNTYPE_OPEN:int = 1;
      
      public static const RETURNTYPE_SUCCESS:int = 2;
      
      public static const RETURNTYPE__MAX:int = 3;
      
      public static const ACTIVITYSTATUS_NONE:int = 0;
      
      public static const ACTIVITYSTATUS_FAKE_INVITER:int = 1;
      
      public static const ACTIVITYSTATUS_FAKE_INVITEE:int = 2;
      
      public static const ACTIVITYSTATUS_INVITER:int = 3;
      
      public static const ACTIVITYSTATUS_INVITEE:int = 4;
      
      public static const ACTIVITYSTATUS__MAX:int = 5;
      
      public var inviterId:int = 0;
      
      public var returnType:int = 0;
      
      public var eventANewHopeQuestCommand:EventANewHopeQuestCommand;
      
      public var eventANewHopeContributorListCommand:EventANewHopeContributorListCommand;
      
      public var bootKeyAmount:Number = 0;
      
      public var inviterName:String = "";
      
      public var errorMessage:BaseStackCommand;
      
      public var activityStatus:int = 0;
      
      public var bootKeyLootId:String = "";
      
      public function EventANewHopeActionCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Number = 0, param7:EventANewHopeContributorListCommand = null, param8:EventANewHopeQuestCommand = null, param9:BaseStackCommand = null)
      {
         super();
         this.inviterId = param3;
         this.returnType = param2;
         if(param8 == null)
         {
            this.eventANewHopeQuestCommand = new EventANewHopeQuestCommand();
         }
         else
         {
            this.eventANewHopeQuestCommand = param8;
         }
         if(param7 == null)
         {
            this.eventANewHopeContributorListCommand = new EventANewHopeContributorListCommand();
         }
         else
         {
            this.eventANewHopeContributorListCommand = param7;
         }
         this.bootKeyAmount = param6;
         this.inviterName = param4;
         if(param9 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param9;
         }
         this.activityStatus = param1;
         this.bootKeyLootId = param5;
      }
      
      public static function get instance() : EventANewHopeActionCommand
      {
         return _instance || (_instance = new EventANewHopeActionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32135;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inviterId = param1.readInt();
         this.inviterId = this.inviterId << 16 % 32 | this.inviterId >>> 32 - 16 % 32;
         this.returnType = param1.readShort();
         this.eventANewHopeQuestCommand = EventANewHopeQuestCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.eventANewHopeQuestCommand)
         {
            this.eventANewHopeQuestCommand.read(param1);
         }
         this.eventANewHopeContributorListCommand = EventANewHopeContributorListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.eventANewHopeContributorListCommand)
         {
            this.eventANewHopeContributorListCommand.read(param1);
         }
         this.bootKeyAmount = param1.readDouble();
         this.inviterName = param1.readUTF();
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.activityStatus = param1.readShort();
         this.bootKeyLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32135);
         param1.writeInt(this.inviterId >>> 16 % 32 | this.inviterId << 32 - 16 % 32);
         param1.writeShort(this.returnType);
         if(null != this.eventANewHopeQuestCommand)
         {
            this.eventANewHopeQuestCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.eventANewHopeContributorListCommand)
         {
            this.eventANewHopeContributorListCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.bootKeyAmount);
         param1.writeUTF(this.inviterName);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.activityStatus);
         param1.writeUTF(this.bootKeyLootId);
      }
   }
}

