package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ChangeClanFirmaCommand implements IModule
   {
      
      private static var _instance:ChangeClanFirmaCommand;
      
      public var success:Boolean = false;
      
      public var companyDateInfoCommand:CompanyDateInfoCommand;
      
      public var errorMsg:BaseStackCommand;
      
      public var firm:int = 0;
      
      public function ChangeClanFirmaCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null, param4:CompanyDateInfoCommand = null)
      {
         super();
         this.success = param2;
         if(param4 == null)
         {
            this.companyDateInfoCommand = new CompanyDateInfoCommand();
         }
         else
         {
            this.companyDateInfoCommand = param4;
         }
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
         this.firm = param1;
      }
      
      public static function get instance() : ChangeClanFirmaCommand
      {
         return _instance || (_instance = new ChangeClanFirmaCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7044;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.companyDateInfoCommand = CompanyDateInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.read(param1);
         }
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.firm = param1.readInt();
         this.firm = this.firm << 1 % 32 | this.firm >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7044);
         param1.writeBoolean(this.success);
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.firm >>> 1 % 32 | this.firm << 32 - 1 % 32);
      }
   }
}

