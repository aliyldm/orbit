package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogMessageCommand implements IModule
   {
      
      private static var _instance:LogMessageCommand;
      
      public static const STYLE_LARGE:int = 0;
      
      public static const STYLE_SMALL:int = 1;
      
      public static const STYLE__MAX:int = 2;
      
      public static const VISIBILITY_LOG:int = 0;
      
      public static const VISIBILITY_SCREEN:int = 1;
      
      public static const VISIBILITY_LOG_AND_SCREEN:int = 2;
      
      public static const VISIBILITY__MAX:int = 3;
      
      public var visibility:int = 0;
      
      public var style:int = 0;
      
      public var message:MessageLocalizedWildcardCommand;
      
      public function LogMessageCommand(param1:int = 0, param2:int = 0, param3:MessageLocalizedWildcardCommand = null)
      {
         super();
         this.visibility = param1;
         this.style = param2;
         if(param3 == null)
         {
            this.message = new MessageLocalizedWildcardCommand();
         }
         else
         {
            this.message = param3;
         }
      }
      
      public static function get instance() : LogMessageCommand
      {
         return _instance || (_instance = new LogMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2590;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.visibility = param1.readShort();
         this.style = param1.readShort();
         this.message = MessageLocalizedWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.message)
         {
            this.message.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2590);
         param1.writeShort(this.visibility);
         param1.writeShort(this.style);
         if(null != this.message)
         {
            this.message.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

