package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CooldownReachedCommand implements IModule
   {
      
      private static var _instance:CooldownReachedCommand;
      
      public var type:CooldownTypeModule;
      
      public function CooldownReachedCommand(param1:CooldownTypeModule = null)
      {
         super();
         if(param1 == null)
         {
            this.type = new CooldownTypeModule();
         }
         else
         {
            this.type = param1;
         }
      }
      
      public static function get instance() : CooldownReachedCommand
      {
         return _instance || (_instance = new CooldownReachedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 91;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = CooldownTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(91);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

