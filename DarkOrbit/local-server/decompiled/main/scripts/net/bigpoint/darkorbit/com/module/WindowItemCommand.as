package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class WindowItemCommand extends ItemCommand
   {
      
      private static var _instance:WindowItemCommand;
      
      public var windowTitle:String = "";
      
      public var posX:int = 0;
      
      public var posY:int = 0;
      
      public var height:int = 0;
      
      public var maximized:Boolean = false;
      
      public var helpText:MessageKeyListWildcardCommand;
      
      public var width:int = 0;
      
      public function WindowItemCommand(param1:String = "", param2:Boolean = false, param3:MessageKeyListWildcardCommand = null, param4:String = "", param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Boolean = false, param10:MessageKeyListWildcardCommand = null)
      {
         super(param1,param2,param3);
         this.windowTitle = param4;
         this.posX = param5;
         this.posY = param6;
         this.height = param8;
         this.maximized = param9;
         if(param10 == null)
         {
            this.helpText = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.helpText = param10;
         }
         this.width = param7;
      }
      
      public static function get instance() : WindowItemCommand
      {
         return _instance || (_instance = new WindowItemCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -5398;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 19;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.windowTitle = param1.readUTF();
         this.posX = param1.readInt();
         this.posX = this.posX >>> 4 % 32 | this.posX << 32 - 4 % 32;
         this.posY = param1.readInt();
         this.posY = this.posY << 6 % 32 | this.posY >>> 32 - 6 % 32;
         this.height = param1.readInt();
         this.height = this.height >>> 5 % 32 | this.height << 32 - 5 % 32;
         this.maximized = param1.readBoolean();
         this.helpText = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.helpText)
         {
            this.helpText.read(param1);
         }
         this.width = param1.readInt();
         this.width = this.width >>> 9 % 32 | this.width << 32 - 9 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5398);
         super.write(param1);
         param1.writeUTF(this.windowTitle);
         param1.writeInt(this.posX << 4 % 32 | this.posX >>> 32 - 4 % 32);
         param1.writeInt(this.posY >>> 6 % 32 | this.posY << 32 - 6 % 32);
         param1.writeInt(this.height << 5 % 32 | this.height >>> 32 - 5 % 32);
         param1.writeBoolean(this.maximized);
         if(null != this.helpText)
         {
            this.helpText.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.width << 9 % 32 | this.width >>> 32 - 9 % 32);
      }
   }
}

