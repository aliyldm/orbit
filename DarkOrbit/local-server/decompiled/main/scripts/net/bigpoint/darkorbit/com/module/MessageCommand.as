package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageCommand implements IModule
   {
      
      private static var _instance:MessageCommand;
      
      public static const DISPLAYTARGET_LOG:int = 0;
      
      public static const DISPLAYTARGET_SCREEN:int = 1;
      
      public static const DISPLAYTARGET_BOTH:int = 2;
      
      public static const DISPLAYTARGET__MAX:int = 3;
      
      public static const DISPLAYSTYLE_BIG:int = 0;
      
      public static const DISPLAYSTYLE_NORMAL:int = 1;
      
      public static const DISPLAYSTYLE__MAX:int = 2;
      
      public var displayTarget:int = 0;
      
      public var displayStyle:int = 0;
      
      public var messageModule:MessageModule;
      
      public function MessageCommand(param1:int = 0, param2:int = 0, param3:MessageModule = null)
      {
         super();
         this.displayTarget = param2;
         this.displayStyle = param1;
         if(param3 == null)
         {
            this.messageModule = new MessageModule();
         }
         else
         {
            this.messageModule = param3;
         }
      }
      
      public static function get instance() : MessageCommand
      {
         return _instance || (_instance = new MessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11445;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.displayTarget = param1.readShort();
         this.displayStyle = param1.readShort();
         this.messageModule = MessageModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.messageModule)
         {
            this.messageModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11445);
         param1.writeShort(this.displayTarget);
         param1.writeShort(this.displayStyle);
         if(null != this.messageModule)
         {
            this.messageModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

