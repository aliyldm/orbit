package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ChangeClanDescriptionCommand implements IModule
   {
      
      private static var _instance:ChangeClanDescriptionCommand;
      
      public var success:Boolean = false;
      
      public var errorMsg:BaseStackCommand;
      
      public var desc:String = "";
      
      public function ChangeClanDescriptionCommand(param1:String = "", param2:Boolean = false, param3:BaseStackCommand = null)
      {
         super();
         this.success = param2;
         if(param3 == null)
         {
            this.errorMsg = new BaseStackCommand();
         }
         else
         {
            this.errorMsg = param3;
         }
         this.desc = param1;
      }
      
      public static function get instance() : ChangeClanDescriptionCommand
      {
         return _instance || (_instance = new ChangeClanDescriptionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29298;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.errorMsg = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMsg)
         {
            this.errorMsg.read(param1);
         }
         this.desc = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29298);
         param1.writeBoolean(this.success);
         if(null != this.errorMsg)
         {
            this.errorMsg.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.desc);
      }
   }
}

