package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ClanDeleteOpenDiploCommand implements IModule
   {
      
      private static var _instance:ClanDeleteOpenDiploCommand;
      
      public var diploId:int = 0;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public function ClanDeleteOpenDiploCommand(param1:int = 0, param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.diploId = param1;
         this.success = param2;
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
      }
      
      public static function get instance() : ClanDeleteOpenDiploCommand
      {
         return _instance || (_instance = new ClanDeleteOpenDiploCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3520;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.diploId = param1.readInt();
         this.diploId = this.diploId >>> 5 % 32 | this.diploId << 32 - 5 % 32;
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3520);
         param1.writeInt(this.diploId << 5 % 32 | this.diploId >>> 32 - 5 % 32);
         param1.writeBoolean(this.success);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

