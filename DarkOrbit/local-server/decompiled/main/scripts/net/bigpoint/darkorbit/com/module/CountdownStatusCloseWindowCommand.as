package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CountdownStatusCloseWindowCommand implements IModule
   {
      
      private static var _instance:CountdownStatusCloseWindowCommand;
      
      public var type:CountdownStatusTypeModule;
      
      public function CountdownStatusCloseWindowCommand(param1:CountdownStatusTypeModule = null)
      {
         super();
         if(param1 == null)
         {
            this.type = new CountdownStatusTypeModule();
         }
         else
         {
            this.type = param1;
         }
      }
      
      public static function get instance() : CountdownStatusCloseWindowCommand
      {
         return _instance || (_instance = new CountdownStatusCloseWindowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4715;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = CountdownStatusTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4715);
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

