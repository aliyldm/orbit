package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProposalVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatTextStylesConstants;
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatEvent;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.time.ServerTime;
   
   public class RichChatMessageRow extends Sprite
   {
      
      private static const MIN_LINE_HEIGHT:Number = 17;
      
      private static const SEGMENT_GAP:Number = 2;
      
      private static const AVATAR_SIZE:Number = 32;
      
      private static const AVATAR_GAP:Number = 8;
      
      private static const AVATAR_TOP_PADDING:Number = 2;
      
      private static const NO_COLOR_OVERRIDE:int = -1;
      
      private static const ADMIN_MESSAGE_COLOR:int = 16711680;
      
      private static const SYSTEM_MESSAGE_COLOR:int = 12107980;
      
      private static const OWN_MESSAGE_COLOR:int = 16777215;
      
      private static const PLAYER_MESSAGE_COLOR_MMO:int = 13665105;
      
      private static const PLAYER_MESSAGE_COLOR_EIC:int = 3046055;
      
      private static const PLAYER_MESSAGE_COLOR_VRU:int = 6603021;
      
      private static const PLAYER_MESSAGE_COLOR_FALLBACK:int = 16777215;
      
      private var _parser:RichChatMessageParser = new RichChatMessageParser();
      
      private var _content:Sprite = new Sprite();
      
      private var _avatar:RichChatRemoteAvatar;
      
      private var _factionIcon:RichChatFactionIcon;
      
      private var _outgoingDisplayUser:DOChatUserVO;
      
      private var _showAvatar:Boolean = true;
      
      private var _message:DOChatMessageVO;
      
      private var _channelName:String;
      
      private var _channelType:String;
      
      private var _alignOutgoingWhispers:Boolean;
      
      private var _availableWidth:Number = 100;
      
      public function RichChatMessageRow(param1:DOChatMessageVO, param2:Number, param3:String = "", param4:Boolean = false, param5:String = "", param6:Boolean = true)
      {
         super();
         this._message = param1;
         this._availableWidth = Math.max(20,param2);
         this._channelName = param3;
         this._alignOutgoingWhispers = param4;
         this._channelType = param5;
         this._showAvatar = param6;
         mouseEnabled = false;
         mouseChildren = true;
         addChild(this._content);
         this.draw();
      }
      
      public function get message() : DOChatMessageVO
      {
         return this._message;
      }
      
      public function set channelName(param1:String) : void
      {
         param1 ||= "";
         if(this._channelName == param1)
         {
            return;
         }
         this._channelName = param1;
         this.draw();
      }
      
      public function set channelType(param1:String) : void
      {
         param1 ||= "";
         if(this._channelType == param1)
         {
            return;
         }
         this._channelType = param1;
         this.draw();
      }
      
      public function set alignOutgoingWhispers(param1:Boolean) : void
      {
         if(this._alignOutgoingWhispers == param1)
         {
            return;
         }
         this._alignOutgoingWhispers = param1;
         this.draw();
      }
      
      public function set availableWidth(param1:Number) : void
      {
         if(this._availableWidth == param1)
         {
            return;
         }
         this._availableWidth = Math.max(20,param1);
         this.draw();
      }
      
      private function get displayUser() : DOChatUserVO
      {
         if(!this._message)
         {
            return null;
         }
         if(!this._alignOutgoingWhispers || this._message.whisperType != DOChatMessageVO.WHISPER_TYPE_YOU)
         {
            return this._message.user;
         }
         if(!this._outgoingDisplayUser)
         {
            this._outgoingDisplayUser = new DOChatUserVO(ChatSettings.userName,DOChatUserVO.TYPE_USER,Hero.isInClan ? "" + Hero.clanTag + "" : "",null,Hero.userID.toString(),null,String(Hero.factionID.value));
         }
         return this._outgoingDisplayUser;
      }
      
      private function draw() : void
      {
         var showAvatar:Boolean;
         var avatarSpace:Number;
         var bodyHasContent:Boolean;
         var segments:Vector.<RichChatMessageSegmentVO>;
         var alignRight:Boolean = false;
         var contentStartX:Number = NaN;
         var textAreaWidth:Number = NaN;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var lineHeight:Number = NaN;
         var lineObjects:Array = null;
         var segment:RichChatMessageSegmentVO = null;
         var bodySpacer:Sprite = null;
         var newLine:Function = function():void
         {
            alignCurrentLine();
            lineObjects = [];
            xPos = contentStartX;
            yPos += lineHeight;
            lineHeight = MIN_LINE_HEIGHT;
         };
         var alignCurrentLine:Function = function():void
         {
            var _loc2_:DisplayObject = null;
            var _loc3_:Number = NaN;
            if(!alignRight || lineObjects.length == 0)
            {
               return;
            }
            var _loc1_:Number = 0;
            for each(_loc2_ in lineObjects)
            {
               _loc1_ = Math.max(_loc1_,_loc2_.x + _loc2_.width - contentStartX);
            }
            _loc3_ = Math.max(0,textAreaWidth - _loc1_);
            for each(_loc2_ in lineObjects)
            {
               _loc2_.x += _loc3_;
            }
         };
         var placeTextChunks:Function = function(param1:String, param2:TextStyleVO, param3:Boolean, param4:String = null, param5:Object = null):void
         {
            var _loc7_:String = null;
            var _loc8_:Array = null;
            var _loc9_:int = 0;
            if(param3)
            {
               if(!containsHtmlTag(param1))
               {
                  placeTextChunks(param1,param2,false,param4,param5);
                  return;
               }
               placeHtmlBlock(param1,param2,param4,param5);
               return;
            }
            var _loc6_:Array = param1.split(/(\s+)/);
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_ != "")
               {
                  if(_loc7_.indexOf("\n") != -1 || _loc7_.indexOf("\r") != -1)
                  {
                     _loc8_ = _loc7_.split(/\r\n|\r|\n/);
                     _loc9_ = 0;
                     while(_loc9_ < _loc8_.length)
                     {
                        if(_loc8_[_loc9_] != "")
                        {
                           placeChunk(_loc8_[_loc9_],param2,param3,param4,param5);
                        }
                        if(_loc9_ < _loc8_.length - 1)
                        {
                           newLine();
                        }
                        _loc9_++;
                     }
                  }
                  else
                  {
                     placeChunk(_loc7_,param2,param3,param4,param5);
                  }
               }
            }
         };
         var placeHtmlBlock:Function = function(param1:String, param2:TextStyleVO, param3:String = null, param4:Object = null):void
         {
            if(xPos > contentStartX)
            {
               newLine();
            }
            var _loc5_:TextField = createTextField(param1,param2,true,messageColorOverride());
            _loc5_.multiline = true;
            _loc5_.wordWrap = true;
            _loc5_.width = textAreaWidth;
            if(param3)
            {
               makeSegmentInteractive(_loc5_,param3,param4);
            }
            _loc5_.x = alignRight ? contentStartX + Math.max(0,textAreaWidth - _loc5_.width) : contentStartX;
            _loc5_.y = yPos;
            _content.addChild(_loc5_);
            bodyHasContent = true;
            yPos += Math.max(MIN_LINE_HEIGHT,_loc5_.height);
            xPos = contentStartX;
            lineHeight = MIN_LINE_HEIGHT;
         };
         var placeChunk:Function = function(param1:String, param2:TextStyleVO, param3:Boolean, param4:String = null, param5:Object = null):void
         {
            var _loc9_:Number = NaN;
            var _loc10_:int = 0;
            var _loc11_:String = null;
            var _loc12_:TextField = null;
            var _loc6_:TextField = createTextField(param1,param2,param3,messageColorOverride());
            if(param4)
            {
               makeSegmentInteractive(_loc6_,param4,param5);
            }
            var _loc7_:Number = contentStartX + textAreaWidth - xPos;
            if(_loc6_.width <= _loc7_ || param1.length <= 1)
            {
               placeInline(_loc6_);
               return;
            }
            if(xPos > contentStartX && _loc6_.width <= textAreaWidth)
            {
               newLine();
               placeInline(_loc6_);
               return;
            }
            var _loc8_:String = param1;
            while(_loc8_.length > 0)
            {
               _loc9_ = contentStartX + textAreaWidth - xPos;
               _loc10_ = int(findFittingCharacterCount(_loc8_,param2,param3,_loc9_));
               _loc11_ = _loc8_.substr(0,_loc10_);
               _loc12_ = createTextField(_loc11_,param2,param3,messageColorOverride());
               if(param4)
               {
                  makeSegmentInteractive(_loc12_,param4,param5);
               }
               placeInline(_loc12_);
               _loc8_ = _loc8_.substr(_loc10_);
               if(_loc8_.length > 0)
               {
                  newLine();
               }
            }
         };
         var findFittingCharacterCount:Function = function(param1:String, param2:TextStyleVO, param3:Boolean, param4:Number):int
         {
            var _loc8_:int = 0;
            var _loc9_:TextField = null;
            var _loc5_:int = 1;
            var _loc6_:int = param1.length;
            var _loc7_:int = 1;
            while(_loc5_ <= _loc6_)
            {
               _loc8_ = int((_loc5_ + _loc6_) * 0.5);
               _loc9_ = createTextField(param1.substr(0,_loc8_),param2,param3,messageColorOverride());
               if(_loc9_.width <= param4)
               {
                  _loc7_ = _loc8_;
                  _loc5_ = _loc8_ + 1;
               }
               else
               {
                  _loc6_ = _loc8_ - 1;
               }
            }
            return _loc7_;
         };
         var placeInline:Function = function(param1:DisplayObject):void
         {
            if(xPos > contentStartX && xPos + param1.width > contentStartX + textAreaWidth)
            {
               newLine();
            }
            param1.x = xPos;
            param1.y = yPos + Math.max(0,lineHeight - param1.height);
            _content.addChild(param1);
            lineObjects.push(param1);
            bodyHasContent = true;
            xPos += param1.width + SEGMENT_GAP;
            lineHeight = Math.max(lineHeight,param1.height);
         };
         while(this._content.numChildren > 0)
         {
            this._content.removeChildAt(0);
         }
         if(!this._message)
         {
            return;
         }
         this.ensureAvatar();
         showAvatar = this.shouldShowAvatar();
         alignRight = this.shouldAlignRight();
         avatarSpace = showAvatar ? AVATAR_SIZE + AVATAR_GAP : 0;
         contentStartX = alignRight ? 0 : avatarSpace;
         textAreaWidth = Math.max(20,this._availableWidth - avatarSpace);
         this.positionAvatar(showAvatar,alignRight);
         xPos = contentStartX;
         yPos = this.drawHeader(alignRight,contentStartX,textAreaWidth);
         lineHeight = MIN_LINE_HEIGHT;
         lineObjects = [];
         bodyHasContent = false;
         segments = this._parser.parse(this._message.message,this.allowMessageHtml());
         if(this._message is DOChatProposalVO)
         {
            segments = new <RichChatMessageSegmentVO>[RichChatMessageSegmentVO.linkSegment(this._message.message,DOChatEvent.ACCEPT_INVITE_CLICKED,(this._message as DOChatProposalVO).inviteVo)];
         }
         for each(segment in segments)
         {
            if(segment.type == RichChatMessageSegmentVO.IMAGE)
            {
               placeInline(RichChatImageRegistry.createImage(segment,this._message.user));
            }
            else if(segment.type == RichChatMessageSegmentVO.LINK)
            {
               placeTextChunks(segment.text,this.messageStyle(),false,segment.eventType,segment.eventPayload);
            }
            else
            {
               placeTextChunks(segment.text,this.messageStyle(),segment.isHtml);
            }
         }
         if(!bodyHasContent)
         {
            bodySpacer = new Sprite();
            bodySpacer.mouseEnabled = false;
            bodySpacer.graphics.beginFill(0,0);
            bodySpacer.graphics.drawRect(0,0,1,MIN_LINE_HEIGHT);
            bodySpacer.graphics.endFill();
            bodySpacer.x = alignRight ? contentStartX + textAreaWidth - 1 : contentStartX;
            bodySpacer.y = yPos;
            this._content.addChild(bodySpacer);
         }
         alignCurrentLine();
      }
      
      private function drawHeader(param1:Boolean, param2:Number, param3:Number) : Number
      {
         var headerLineHeight:Number;
         var headerWidth:Number;
         var xPos:Number;
         var headerObjects:Array = null;
         var headerStyle:TextStyleVO = null;
         var headerObject:DisplayObject = null;
         var factionIcon:RichChatFactionIcon = null;
         var alignRight:Boolean = param1;
         var contentStartX:Number = param2;
         var textAreaWidth:Number = param3;
         var addHeaderText:Function = function(param1:String, param2:Boolean = false):void
         {
            if(!param1)
            {
               return;
            }
            var _loc3_:TextField = createTextField(param1,headerStyle,false,messageColorOverride());
            if(param2)
            {
               makeSenderInteractive(_loc3_);
            }
            headerObjects.push(_loc3_);
         };
         headerObjects = [];
         headerStyle = this.senderStyle();
         var user:DOChatUserVO = this.displayUser;
         if(this.isAdminMessage())
         {
            addHeaderText(this.createAdminChannelText());
            addHeaderText(this.getDisplayUsername(user),true);
         }
         else
         {
            if(alignRight)
            {
               addHeaderText(this.formatMessageTime());
            }
            addHeaderText(this.createChannelText());
            addHeaderText(this.createClanText(user));
            addHeaderText(this.getDisplayUsername(user),true);
            factionIcon = this.getFactionIcon();
            if(factionIcon)
            {
               headerObjects.push(factionIcon);
            }
            if(!alignRight)
            {
               addHeaderText(this.formatMessageTime());
            }
         }
         headerLineHeight = MIN_LINE_HEIGHT;
         headerWidth = 0;
         for each(headerObject in headerObjects)
         {
            headerLineHeight = Math.max(headerLineHeight,headerObject.height);
            headerWidth += headerObject.width;
         }
         if(headerObjects.length > 1)
         {
            headerWidth += SEGMENT_GAP * (headerObjects.length - 1);
         }
         xPos = contentStartX;
         if(alignRight)
         {
            xPos += Math.max(0,textAreaWidth - headerWidth);
         }
         for each(headerObject in headerObjects)
         {
            headerObject.x = xPos;
            headerObject.y = Math.max(0,(headerLineHeight - headerObject.height) * 0.5);
            this._content.addChild(headerObject);
            xPos += headerObject.width + SEGMENT_GAP;
         }
         return headerLineHeight;
      }
      
      private function ensureAvatar() : void
      {
         if(Boolean(this._avatar) || !this.shouldShowAvatar())
         {
            return;
         }
         var _loc1_:DOChatUserVO = this.displayUser;
         this._avatar = new RichChatRemoteAvatar(_loc1_.avatarUrl,AVATAR_SIZE,AVATAR_SIZE,_loc1_);
         addChildAt(this._avatar,0);
      }
      
      private function positionAvatar(param1:Boolean, param2:Boolean) : void
      {
         if(!this._avatar)
         {
            return;
         }
         this._avatar.visible = param1;
         this._avatar.x = param2 ? Math.max(0,this._availableWidth - AVATAR_SIZE) : 0;
         this._avatar.y = AVATAR_TOP_PADDING;
      }
      
      private function shouldAlignRight() : Boolean
      {
         return this._message != null && (this._alignOutgoingWhispers && this._message.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU || this.isCurrentUserChannelMessage());
      }
      
      private function isCurrentUserChannelMessage() : Boolean
      {
         return this._message != null && this._message.whisperType == DOChatMessageVO.WHISPER_TYPE_NONE && this._message.user != null && ChatSettings.userName != null && ChatSettings.userName != "" && this._message.user.username == ChatSettings.userName;
      }
      
      private function getFactionIcon() : RichChatFactionIcon
      {
         if(!ChatSettings.isNew)
         {
            this._factionIcon = null;
            return null;
         }
         if(this.isAdminMessage())
         {
            this._factionIcon = null;
            return null;
         }
         var _loc1_:DOChatUserVO = this.displayUser;
         var _loc2_:int = _loc1_ ? int(_loc1_.factionId) : 0;
         if((_loc2_ < 1 || _loc2_ > 3) && this.shouldAlignRight() && Boolean(Hero.factionID))
         {
            _loc2_ = int(Hero.factionID.value);
         }
         if(_loc2_ < 1 || _loc2_ > 3)
         {
            this._factionIcon = null;
            return null;
         }
         if(!this._factionIcon || this._factionIcon.factionId != _loc2_)
         {
            this._factionIcon = new RichChatFactionIcon(_loc2_,this.senderStyle());
         }
         return this._factionIcon;
      }
      
      private function shouldShowAvatar() : Boolean
      {
         var _loc1_:DOChatUserVO = this.displayUser;
         return this._showAvatar && _loc1_ != null && _loc1_.username != "" && _loc1_.usertype != DOChatUserVO.TYPE_SYSTEM && _loc1_.usertype != DOChatUserVO.TYPE_CMD;
      }
      
      private function createChannelText() : String
      {
         var _loc1_:String = this.trimText(this._channelName);
         if(_loc1_ != "")
         {
            return "[" + _loc1_ + "]";
         }
         if(Boolean(this._message) && (this._message.whisperType == DOChatMessageVO.WHISPER_TYPE_THEY || this._message.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU))
         {
            return "[" + BPLocale.getItemInCategory("chat","chat_chat_whisper") + "]";
         }
         return "";
      }
      
      private function createAdminChannelText() : String
      {
         return "[" + BPLocale.getItemInCategory("chat","chat_chat_channel_admin") + "]";
      }
      
      private function isAdminMessage() : Boolean
      {
         return this._message != null && this._message.user != null && this._message.user.usertype == DOChatUserVO.TYPE_ADMIN;
      }
      
      private function messageColorOverride() : int
      {
         if(this.isAdminMessage())
         {
            return ADMIN_MESSAGE_COLOR;
         }
         if(this.isSystemMessage())
         {
            return SYSTEM_MESSAGE_COLOR;
         }
         if(this.isOwnMessage())
         {
            return OWN_MESSAGE_COLOR;
         }
         return this.getPlayerFactionMessageColor();
      }
      
      private function isOwnMessage() : Boolean
      {
         return this._message != null && (this._message.whisperType == DOChatMessageVO.WHISPER_TYPE_YOU || this.isCurrentUserChannelMessage());
      }
      
      private function isSystemMessage() : Boolean
      {
         return this._message != null && this._message.user != null && this._message.user.usertype == DOChatUserVO.TYPE_SYSTEM;
      }
      
      private function getPlayerFactionMessageColor() : int
      {
         if(!this.isPlayerMessage())
         {
            return NO_COLOR_OVERRIDE;
         }
         var _loc1_:int = int(this._message.user.factionId);
         switch(_loc1_)
         {
            case FactionModule.FACTION_MMO:
               return PLAYER_MESSAGE_COLOR_MMO;
            case FactionModule.FACTION_EIC:
               return PLAYER_MESSAGE_COLOR_EIC;
            case FactionModule.FACTION_VRU:
               return PLAYER_MESSAGE_COLOR_VRU;
            default:
               return PLAYER_MESSAGE_COLOR_FALLBACK;
         }
      }
      
      private function isPlayerMessage() : Boolean
      {
         return this._message != null && this._message.user != null && this._message.user.usertype != DOChatUserVO.TYPE_SYSTEM && this._message.user.usertype != DOChatUserVO.TYPE_CMD;
      }
      
      private function createClanText(param1:DOChatUserVO) : String
      {
         var _loc2_:String = this.trimText(param1 ? param1.clanTag : "");
         if(_loc2_ == "" || this.isNoClanTag(_loc2_))
         {
            return "";
         }
         return "[" + _loc2_ + "]";
      }
      
      private function getDisplayUsername(param1:DOChatUserVO) : String
      {
         return Boolean(param1) && Boolean(param1.username) ? param1.username : "";
      }
      
      private function formatMessageTime() : String
      {
         var _loc1_:Number = this._message ? this._message.timestamp : NaN;
         if(isNaN(_loc1_) || _loc1_ <= 0)
         {
            return "";
         }
         return this.formatTimestamp(_loc1_);
      }
      
      private function formatTimestamp(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 + ServerTime.instance.utcTimeOffset);
         return _loc2_.fullYearUTC + "-" + this.padTime(_loc2_.monthUTC + 1) + "-" + this.padTime(_loc2_.dateUTC) + " " + this.padTime(_loc2_.hoursUTC) + ":" + this.padTime(_loc2_.minutesUTC) + ":" + this.padTime(_loc2_.secondsUTC);
      }
      
      private function padTime(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : String(param1);
      }
      
      private function trimText(param1:String) : String
      {
         return param1 ? param1.replace(/^\s+|\s+$/g,"") : "";
      }
      
      private function isNoClanTag(param1:String) : Boolean
      {
         var _loc2_:String = param1.toLowerCase();
         return _loc2_ == Hero.NO_CLAN.toLowerCase() || Boolean(Hero.NO_CLAN_LOCA) && _loc2_ == Hero.NO_CLAN_LOCA.toLowerCase();
      }
      
      private function senderStyle() : TextStyleVO
      {
         var _loc1_:DOChatUserVO = this._message ? this._message.user : null;
         var _loc2_:String = this._message ? this._message.whisperType : "";
         if(_loc2_ == DOChatMessageVO.WHISPER_TYPE_THEY || _loc2_ == DOChatMessageVO.WHISPER_TYPE_YOU)
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_WHISPER);
         }
         if(Boolean(_loc1_) && _loc1_.isMod())
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_MOD);
         }
         if(Boolean(_loc1_) && _loc1_.isSupp())
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_SUPP);
         }
         if(Boolean(_loc1_) && (_loc1_.usertype == DOChatUserVO.TYPE_SYSTEM || _loc1_.usertype == DOChatUserVO.TYPE_CMD))
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_SYSTEM);
         }
         return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_DEFAULT);
      }
      
      private function messageStyle() : TextStyleVO
      {
         var _loc1_:DOChatUserVO = this._message ? this._message.user : null;
         if(this._message is DOChatProposalVO)
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_SENDER_INVITE);
         }
         if(Boolean(_loc1_) && _loc1_.isMod())
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_MESSAGE_MOD);
         }
         if(Boolean(_loc1_) && _loc1_.isSupp())
         {
            return this.getStyle(ChatTextStylesConstants.STYLE_MESSAGE_SUPP);
         }
         return this.getStyle(ChatTextStylesConstants.STYLE_MESSAGE_DEFAULT);
      }
      
      private function allowMessageHtml() : Boolean
      {
         return this._message != null && this._message.user != null && (this._message.user.usertype == DOChatUserVO.TYPE_SYSTEM || this._message.user.usertype == DOChatUserVO.TYPE_CMD);
      }
      
      private function containsHtmlTag(param1:String) : Boolean
      {
         return param1 != null && /<[^>]+>/.test(param1);
      }
      
      private function createTextField(param1:String, param2:TextStyleVO, param3:Boolean, param4:int = -1) : TextField
      {
         var _loc5_:TextField = new TextField();
         param1 ||= "";
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.multiline = false;
         _loc5_.selectable = false;
         _loc5_.htmlText = this.wrapText(param3 ? param1 : HtmlTextUtils.escapeHtmlText(param1),param2,param4);
         return _loc5_;
      }
      
      private function wrapText(param1:String, param2:TextStyleVO, param3:int = -1) : String
      {
         var _loc4_:uint = param3 == NO_COLOR_OVERRIDE ? param2.textColor : uint(param3);
         var _loc5_:String = "<font color=\'" + HtmlTextUtils.convertColorValueIntoHTMLFormat(_loc4_) + "\' face=\'" + param2.fontName + "\'>" + param1 + "</font>";
         if(param2.bold)
         {
            _loc5_ = "<b>" + _loc5_ + "</b>";
         }
         if(param2.underline)
         {
            _loc5_ = "<u>" + _loc5_ + "</u>";
         }
         return _loc5_;
      }
      
      private function makeSenderInteractive(param1:TextField) : void
      {
         var _loc2_:DOChatUserVO = this.displayUser;
         if(!_loc2_ || !_loc2_.username || _loc2_.username == ChatSettings.userName)
         {
            return;
         }
         if(_loc2_.usertype == DOChatUserVO.TYPE_ADMIN)
         {
            return;
         }
         if(_loc2_.usertype != DOChatUserVO.TYPE_USER && _loc2_.usertype != DOChatUserVO.TYPE_CMD)
         {
            return;
         }
         param1.mouseEnabled = true;
         param1.addEventListener(MouseEvent.CLICK,this.handleSenderClicked);
      }
      
      private function makeSegmentInteractive(param1:TextField, param2:String, param3:Object) : void
      {
         var field:TextField = param1;
         var eventType:String = param2;
         var eventPayload:Object = param3;
         field.mouseEnabled = true;
         field.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            dispatchEvent(new DOChatEvent(eventType,eventPayload,true));
         });
      }
      
      private function getStyle(param1:String) : TextStyleVO
      {
         return TextStyleRepository.getInstance().getByName(param1);
      }
      
      private function handleSenderClicked(param1:MouseEvent) : void
      {
         var _loc2_:DOChatUserVO = this.displayUser;
         if(!_loc2_ || !_loc2_.username || _loc2_.username == ChatSettings.userName)
         {
            return;
         }
         if(_loc2_.usertype == DOChatUserVO.TYPE_ADMIN)
         {
            return;
         }
         if(_loc2_.usertype == DOChatUserVO.TYPE_CMD)
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.CMD_CLICKED,_loc2_.username,true));
         }
         else
         {
            dispatchEvent(new DOChatEvent(DOChatEvent.USERNAME_CLICKED,_loc2_.username,true));
         }
      }
   }
}

