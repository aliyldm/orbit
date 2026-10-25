package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ApplyClanCommand implements IModule
   {
      
      private static var _instance:ApplyClanCommand;
      
      public var applyId:int = 0;
      
      public var credits:int = 0;
      
      public var errorMsg:BaseStackCommand;
      
      public var clanId:int = 0;
      
      public var success:Boolean = false;
      
      public function ApplyClanCommand(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:BaseStackCommand = null, param5:int = 0)
      {
         super();
         this.applyId = param2;
         this.credits = param5;
         if(param4 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param4;
         }
         this.clanId = param1;
         this.success = param3;
      }
      
      public static function get instance() : ApplyClanCommand
      {
         return _instance || (_instance = new ApplyClanCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9574;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.applyId = param1.readInt();
         this.applyId = this.applyId >>> 9 % 32 | this.applyId << 32 - 9 % 32;
         this.credits = param1.readInt();
         this.credits = this.credits >>> 14 % 32 | this.credits << 32 - 14 % 32;
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.clanId = param1.readInt();
         this.clanId = this.clanId >>> 11 % 32 | this.clanId << 32 - 11 % 32;
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9574);
         param1.writeInt(this.applyId << 9 % 32 | this.applyId >>> 32 - 9 % 32);
         param1.writeInt(this.credits << 14 % 32 | this.credits >>> 32 - 14 % 32);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.clanId << 11 % 32 | this.clanId >>> 32 - 11 % 32);
         param1.writeBoolean(this.success);
      }
   }
}

