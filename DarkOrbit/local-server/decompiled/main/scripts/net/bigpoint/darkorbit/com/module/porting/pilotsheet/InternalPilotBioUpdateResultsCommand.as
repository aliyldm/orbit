package net.bigpoint.darkorbit.com.module.porting.pilotsheet
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class InternalPilotBioUpdateResultsCommand implements IModule
   {
      
      private static var _instance:InternalPilotBioUpdateResultsCommand;
      
      public var success:Boolean = false;
      
      public var baseStackCommand:BaseStackCommand;
      
      public function InternalPilotBioUpdateResultsCommand(param1:Boolean = false, param2:BaseStackCommand = null)
      {
         super();
         this.success = param1;
         if(param2 == null)
         {
            this.baseStackCommand = new BaseStackCommand();
         }
         else
         {
            this.baseStackCommand = param2;
         }
      }
      
      public static function get instance() : InternalPilotBioUpdateResultsCommand
      {
         return _instance || (_instance = new InternalPilotBioUpdateResultsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5412;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.baseStackCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.baseStackCommand)
         {
            this.baseStackCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5412);
         param1.writeBoolean(this.success);
         if(null != this.baseStackCommand)
         {
            this.baseStackCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

