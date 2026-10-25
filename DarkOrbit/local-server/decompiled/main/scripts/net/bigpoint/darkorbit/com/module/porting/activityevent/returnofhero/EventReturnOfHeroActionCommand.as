package net.bigpoint.darkorbit.com.module.porting.activityevent.returnofhero
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class EventReturnOfHeroActionCommand implements IModule
   {
      
      private static var _instance:EventReturnOfHeroActionCommand;
      
      public static const RETURNTYPE_ERROR:int = 0;
      
      public static const RETURNTYPE_OPEN:int = 1;
      
      public static const RETURNTYPE_SUCCESS:int = 2;
      
      public static const RETURNTYPE_NONE:int = 3;
      
      public static const RETURNTYPE__MAX:int = 4;
      
      public static const ACTIVITYSTATUS_NONE:int = 0;
      
      public static const ACTIVITYSTATUS_FALSE:int = 1;
      
      public static const ACTIVITYSTATUS_TRUE:int = 2;
      
      public static const ACTIVITYSTATUS_INVITER:int = 3;
      
      public static const ACTIVITYSTATUS_INVITEE:int = 4;
      
      public static const ACTIVITYSTATUS__MAX:int = 5;
      
      public var btnEnable:Boolean = false;
      
      public var eventReturnOfHeroQuestCommand:EventReturnOfHeroQuestCommand;
      
      public var returnType:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public var inviterName:String = "";
      
      public var bootKeyLootId:String = "";
      
      public var inviterId:int = 0;
      
      public var eventReturnOfHeroContributorListCommand:EventReturnOfHeroContributorListCommand;
      
      public var activityStatus:int = 0;
      
      public var bootKeyAmount:Number = 0;
      
      public function EventReturnOfHeroActionCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Number = 0, param7:EventReturnOfHeroContributorListCommand = null, param8:EventReturnOfHeroQuestCommand = null, param9:BaseStackCommand = null, param10:Boolean = false)
      {
         super();
         this.btnEnable = param10;
         if(param8 == null)
         {
            this.eventReturnOfHeroQuestCommand = new EventReturnOfHeroQuestCommand();
         }
         else
         {
            this.eventReturnOfHeroQuestCommand = param8;
         }
         this.returnType = param2;
         if(param9 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param9;
         }
         this.inviterName = param4;
         this.bootKeyLootId = param5;
         this.inviterId = param3;
         if(param7 == null)
         {
            this.eventReturnOfHeroContributorListCommand = new EventReturnOfHeroContributorListCommand();
         }
         else
         {
            this.eventReturnOfHeroContributorListCommand = param7;
         }
         this.activityStatus = param1;
         this.bootKeyAmount = param6;
      }
      
      public static function get instance() : EventReturnOfHeroActionCommand
      {
         return _instance || (_instance = new EventReturnOfHeroActionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18677;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.btnEnable = param1.readBoolean();
         this.eventReturnOfHeroQuestCommand = EventReturnOfHeroQuestCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.eventReturnOfHeroQuestCommand)
         {
            this.eventReturnOfHeroQuestCommand.read(param1);
         }
         this.returnType = param1.readShort();
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.inviterName = param1.readUTF();
         this.bootKeyLootId = param1.readUTF();
         this.inviterId = param1.readInt();
         this.inviterId = this.inviterId >>> 16 % 32 | this.inviterId << 32 - 16 % 32;
         this.eventReturnOfHeroContributorListCommand = EventReturnOfHeroContributorListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.eventReturnOfHeroContributorListCommand)
         {
            this.eventReturnOfHeroContributorListCommand.read(param1);
         }
         this.activityStatus = param1.readShort();
         this.bootKeyAmount = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18677);
         param1.writeBoolean(this.btnEnable);
         if(null != this.eventReturnOfHeroQuestCommand)
         {
            this.eventReturnOfHeroQuestCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.returnType);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.inviterName);
         param1.writeUTF(this.bootKeyLootId);
         param1.writeInt(this.inviterId << 16 % 32 | this.inviterId >>> 32 - 16 % 32);
         if(null != this.eventReturnOfHeroContributorListCommand)
         {
            this.eventReturnOfHeroContributorListCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.activityStatus);
         param1.writeDouble(this.bootKeyAmount);
      }
   }
}

