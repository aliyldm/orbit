package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanDeleteDiploCommand implements IModule
   {
      
      private static var _instance:ClanDeleteDiploCommand;
      
      public var diploId:int = 0;
      
      public var baseStackCommand:BaseStackCommand;
      
      public var success:Boolean = false;
      
      public function ClanDeleteDiploCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.diploId = param1;
         if(param3 == null)
         {
            this.baseStackCommand = new BaseStackCommand();
         }
         else
         {
            this.baseStackCommand = param3;
         }
         this.success = param2;
      }
      
      public static function get instance() : ClanDeleteDiploCommand
      {
         return _instance || (_instance = new ClanDeleteDiploCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14536;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.diploId = param1.readInt();
         this.diploId = this.diploId >>> 10 % 32 | this.diploId << 32 - 10 % 32;
         this.baseStackCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.baseStackCommand)
         {
            this.baseStackCommand.read(param1);
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14536);
         param1.writeInt(this.diploId << 10 % 32 | this.diploId >>> 32 - 10 % 32);
         if(null != this.baseStackCommand)
         {
            this.baseStackCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.success);
      }
   }
}

