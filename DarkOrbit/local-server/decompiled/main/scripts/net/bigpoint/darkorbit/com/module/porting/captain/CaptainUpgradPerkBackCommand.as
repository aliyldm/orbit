package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class CaptainUpgradPerkBackCommand implements IModule
   {
      
      private static var _instance:CaptainUpgradPerkBackCommand;
      
      public var errorId:BaseStackCommand;
      
      public var level:int = 0;
      
      public var perkId:int = 0;
      
      public var captainId:int = 0;
      
      public var result:Boolean = false;
      
      public function CaptainUpgradPerkBackCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:BaseStackCommand = null)
      {
         super();
         if(param5 == null)
         {
            this.errorId = new BaseStackCommand();
         }
         else
         {
            this.errorId = param5;
         }
         this.level = param3;
         this.perkId = param2;
         this.captainId = param1;
         this.result = param4;
      }
      
      public static function get instance() : CaptainUpgradPerkBackCommand
      {
         return _instance || (_instance = new CaptainUpgradPerkBackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7107;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorId = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorId)
         {
            this.errorId.read(param1);
         }
         this.level = param1.readInt();
         this.level = this.level << 10 % 32 | this.level >>> 32 - 10 % 32;
         this.perkId = param1.readInt();
         this.perkId = this.perkId << 16 % 32 | this.perkId >>> 32 - 16 % 32;
         this.captainId = param1.readInt();
         this.captainId = this.captainId << 5 % 32 | this.captainId >>> 32 - 5 % 32;
         this.result = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7107);
         if(null != this.errorId)
         {
            this.errorId.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.level >>> 10 % 32 | this.level << 32 - 10 % 32);
         param1.writeInt(this.perkId >>> 16 % 32 | this.perkId << 32 - 16 % 32);
         param1.writeInt(this.captainId >>> 5 % 32 | this.captainId << 32 - 5 % 32);
         param1.writeBoolean(this.result);
      }
   }
}

