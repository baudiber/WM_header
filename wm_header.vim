" **************************************************************************** "
"                                                                              "
"                                                          .-+#####+'          "
"    WMheader.vim                                           -+####+     /#     "
"                                                      .'   .+###+'     `+/    "
"    By: B.Audibert <baudibert@winter-mushroom.com    .##    -##+'       -.    "
"                                                     .##:   '#+/    /-        "
"    Created: 2017/11/30 22:19:45 by B.Audibert       -+#+    :     +##.       "
"    Updated: 2017/11/30 22:19:50 by baudiber         ###   ########.fr        "
"                                                      -+++.      /+####+'     "
"    Copyright :                                        `++.     .+######+     "
"    Winter Mushroom SAS 2017                              `.   .++++:#-'      "
"                                                                              "
" **************************************************************************** "

let s:asciiart = [
        	\"     .-+#####+'      ",
   			\"      -+####+     /# ",
      		\" .'   .+###+'     `+/",
       		\".##    -##+'       -.",
      		\".##:   '#+/    /-    ",
   			\"-+#+    :     +##.   ",
      		\".+#+:        +###+`  ",
   			\" -+++.      /+####+' ",
      		\"  `++.     .+######+ ",
       		\"     `.   .++++:#-'  "
			\]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php':
			\['/*', '*/', '*'],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->', '*'],
			\'\.js$':
			\['//', '//', '*'],
			\'\.tex$':
			\['%', '%', '*'],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)', '*'],
			\'\.vim$\|\vimrc$':
			\['"', '"', '*'],
			\'\.el$\|\emacs$':
			\[';', ';', '*'],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '!', '/']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= '#'
	let s:fill	= '*'

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
			let s:fill	= s:types[type][2]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
	let l:left = strpart(a:left, 0, s:length - s:margin * 3 - strlen(a:right) + 1)

	return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 14 " top and bottom line
		return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
	elseif a:n == 2 || a:n == 13 " blank line
		return s:textline('', '')
	elseif a:n == 3 || a:n == 5 || a:n == 7 || a:n == 10 " empty with ascii
		return s:textline('', s:ascii(a:n))
	elseif a:n == 4 " filename
		return s:textline(s:filename(), s:ascii(a:n))
	elseif a:n == 6 " author
		return s:textline("By: " . s:user() . " <" . s:mail() . ">", s:ascii(a:n))
	elseif a:n == 8 " created
		return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
	elseif a:n == 9 " updated
		return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
	elseif a:n == 11 " copyright
		return s:textline("Copyright :", s:ascii(a:n))
	elseif a:n == 12 " copyright
		return s:textline(s:wm(), s:ascii(a:n))
	endif
endfunction

function! s:user()
	let l:user = "B.Audibert"
	return l:user
endfunction

function! s:mail()
	let l:mail = "baudibert@winter-mushroom.com"
	return l:mail
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
	let l:line = 14

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:wm()
	let l:wm = "Winter Mushroom SAS 2019"
	return l:wm
endfunction

function! s:update()
	call s:filetype()
	if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
		if &mod
			call setline(9, s:line(9))
		endif
		call setline(4, s:line(4))
		return 0
	endif
	return 1
endfunction

function! s:WMheader()
	if s:update()
		call s:insert()
	endif
endfunction

" Bind command and shortcut
command! WMheader call s:WMheader ()
nmap <f2> <esc>:WMheader<CR>
autocmd BufWritePre * call s:update ()
