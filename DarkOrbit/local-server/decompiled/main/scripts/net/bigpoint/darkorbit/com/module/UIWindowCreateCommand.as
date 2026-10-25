package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowCreateCommand implements IModule
   {
      
      private static var _instance:UIWindowCreateCommand;
      
      public var alignement:AlignmentModule;
      
      public var windowId:int = 0;
      
      public var videoId:int = 0;
      
      public var showButtons:Boolean = false;
      
      public var textKeys:Vector.<String>;
      
      public function UIWindowCreateCommand(param1:AlignmentModule = null, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:Vector.<String> = null)
      {
         super();
         if(param1 == null)
         {
            this.alignement = new AlignmentModule();
         }
         else
         {
            this.alignement = param1;
         }
         this.windowId = param2;
         this.videoId = param3;
         this.showButtons = param4;
         if(param5 == null)
         {
            this.textKeys = new Vector.<String>();
         }
         else
         {
            this.textKeys = param5;
         }
      }
      
      public static function get instance() : UIWindowCreateCommand
      {
         return _instance || (_instance = new UIWindowCreateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 117;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.alignement = AlignmentModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.alignement)
         {
            this.alignement.read(param1);
         }
         this.windowId = param1.readInt();
         this.windowId = this.windowId << 4 % 32 | this.windowId >>> 32 - 4 % 32;
         this.videoId = param1.readInt();
         this.videoId = this.videoId << 13 % 32 | this.videoId >>> 32 - 13 % 32;
         this.showButtons = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.textKeys.length > 0)
         {
            this.textKeys.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.textKeys.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(117);
         if(null != this.alignement)
         {
            this.alignement.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.windowId >>> 4 % 32 | this.windowId << 32 - 4 % 32);
         param1.writeInt(this.videoId >>> 13 % 32 | this.videoId << 32 - 13 % 32);
         param1.writeBoolean(this.showButtons);
         param1.writeByte(this.textKeys.length);
         for each(_loc2_ in this.textKeys)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

